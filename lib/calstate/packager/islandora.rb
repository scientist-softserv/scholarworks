# frozen_string_literal: true

require 'colorize'
require 'rubygems'
require 'time'
require 'yaml'
require 'zip'

module CalState
  module Packager
    #
    # Islandora migration
    #
    class Islandora
      #
      # New Islandora packager
      #
      # @param campus [String]      campus slug
      # @param type [String]        work type (e.g., Thesis)
      #
      def initialize(campus, type)
        @campus = campus
        @type = type

        # config and loggers
        config_file = 'config/packager/' + campus + '.yml'
        @config = OpenStruct.new(YAML.load_file(config_file))
        @log = Packager::Log.new(@config['output_level'])

        @visibility = @config['visibility'] ||= 'open'
        @log.info ' Work type ' + @type
        @log.info ' Visibility ' + @visibility

        unless @config['metadata_file']
          raise 'Must set metadata_file in the config'
        end
        raise 'Must set data_file in the config' unless @config['data_file']
        raise 'Must set campus name in config' unless @config['campus']

        # set working directories
        @input_dir = @config['input_dir']
        @complete_dir = initialize_directory(@input_dir + '_complete')
        @error_dir = initialize_directory(@input_dir + '_error')
        @log.info 'input dir ' + @input_dir
        @log.info 'complete dir ' + @complete_dir
        @log.info 'error_dir ' + @error_dir

        @log.info 'Starting rake task packager:islandora'.green
        @log.info 'Campus: ' + @config['campus'].yellow
        @log.info 'Loading import package from ' + @input_dir
      end

      #
      # Process all items
      #
      # @param throttle [Integer]  seconds to throttle between
      #
      def process_items(throttle)
        Dir.each_child(@input_dir) do |dirname|
          @log.info "\n\nProcessing " + dirname
          process_dir(dirname)
          sleep(throttle.to_i) unless throttle.nil?
        end
      end

      #
      # Rename the folders to islandora_id
      #
      # otherwise the folders are named with the title of the work (weird)
      #
      def rename_folders
        Dir.each_child(@input_dir) do |file|
          m = file.match(/\(islandora:([0-9]*)\)/)
          unless m.nil?
            FileUtils.mv(@input_dir + '/' + file,
                         @input_dir + '/' + 'islandora_' + m[1])
          end
        end
      end

      protected

      #
      # Directory clean-up
      #
      # @param source_path [String]  input directory path
      # @param dest_path [String]    destination directory path
      #
      def cleanup(source_path, dest_path)
        # create directories if needed
        cur_path = ''
        paths = dest_path.split('/')

        paths.each do |dirname|
          next if dirname.nil? || dirname.empty?

          cur_path = cur_path + '/' + dirname
          Dir.mkdir(cur_path) unless Dir.exist?(cur_path)
        end

        # now move files over to new dest directory
        Dir.glob(File.join(@input_dir + '/' + source_path, '*')).each do |f|
          FileUtils.mv(f, dest_path)
        end

        # now remove the source dir
        delete_dir = File.join(@input_dir, source_path)
        Dir.delete delete_dir if File.exist?(delete_dir)
      end

      #
      # Process all files in a directory
      #
      # @param path [String]  path to directory
      #
      def process_dir(path)
        return unless File.directory?(File.join(@input_dir, path))

        # process subdirectories
        Dir.each_child(File.join(@input_dir, path)) do |subdir|
          process_dir(path + '/' + subdir)
        end

        sleep(3)
        metadata_file = ''
        valid_metadata = false
        metadata_files = @config['metadata_file'].split('|')
        metadata_files.each do |name|
          metadata_file = File.join(@input_dir + '/' + path, name)
          if File.exist?(metadata_file)
            valid_metadata = true
            break
          end
        end

        done_dir = File.join(@error_dir, path)

        if valid_metadata
          # we still need to check for PDF file
          data_file = nil
          data_files = @config['data_file'].split('|')
          data_files.each do |fileext|
            Dir.glob(@input_dir + '/' + path + '/*.' + fileext) do |filename|
              data_file = filename
              break
            end
            next if data_file.nil?

            begin
              @log.info 'Using metatadata file ' + metadata_file
              @log.info 'Using data file ' + data_file
              process_metadata(path, metadata_file, data_file)
              done_dir = File.join(@complete_dir, path)
            rescue StandardError => e
              @log.error e.class.to_s.red
              @log.error e
              raise e
            end
            break
          end
        end

        cleanup(path, done_dir)
      end

      #
      # Process the DC Record file in a directory
      # creates new work(s) based on content
      #
      # @param dir_name [String]       the directory of the extracted package
      # @param metadata_file [String]  location of metadata file
      # @param data_file [String]      the file to upload
      #
      # @raise RuntimeError if no METS file found
      #
      def process_metadata(dir_name, metadata_file, data_file)
        @log.info 'Processing metadata file'
        @log.info 'metadata file ' + metadata_file

        # make sure we actually have a mets file
        unless File.exist?(metadata_file)
          raise 'No metadata file found in ' + dir_name
        end

        # parse it
        dom = Nokogiri::XML(File.open(metadata_file))

        # determine the type of object
        # if this is a dspace item, create a new work
        # otherwise process the items from this community/collection

        create_work_and_files(dom, data_file)
      end

      #
      # Create new work and attach any files
      #
      # @param dom [Nokogiri::XML::Document]  DOMDocument of METS file
      # @param data_file [String]             the file to upload
      #
      def create_work_and_files(dom, data_file)
        @log.info 'Ingesting ' + @type

        start_time = DateTime.now

        # data mapper
        params = collect_params(dom)
        pp params if @debug

        @log.info 'Creating Hyrax work...'
        work = create_new_work(params)

        if @config['metadata_only']
          @log.info 'Metadata only'
        else
          @log.info 'Getting uploaded files'
          uploaded_files = get_files_to_upload(data_file)

          @log.info 'Attaching file(s) to work job...'
          AttachFilesToWorkJob.perform_now(work, uploaded_files)
        end

        # Register work in handle
        HandleRegisterJob.perform_now(work)

        # record the time it took
        end_time = Time.now.minus_with_coercion(start_time)
        total_time = Time.at(end_time.to_i.abs).utc.strftime('%H:%M:%S')
        @log.info 'Total time: ' + total_time
        @log.info 'DONE!'.green
      end

      #
      # Create a new Hyrax work
      #
      # @param params [Hash]  the field/xpath mapper
      #
      # @return [ActiveFedora::Base] the work
      #
      def create_new_work(params)
        @log.info 'Configuring work attributes'

        # set depositor
        depositor = User.find_by_user_key(@config['depositor'])
        raise 'User ' + @config['depositor'] + ' not found.' if depositor.nil?

        # set noid
        id = Noid::Rails::Service.new.minter.mint

        # set resource type
        resource_type = @type || 'Thesis'
        params['resource_type'] = ['Masters Thesis'] if resource_type.downcase == 'thesis'

        # set visibility
        params['visibility'] = @visibility

        # set admin set to deposit into
        params['admin_set_id'] = @config['admin_set_id'] unless @config['admin_set_id'].nil?

        # set campus
        params['campus'] = [@config['campus']]

        @log.info 'Creating a new ' + resource_type + ' with id:' + id

        raise 'No mapping for ' + resource_type if @config['type_to_work_map'][resource_type].nil?

        model_name = @config['type_to_work_map'][resource_type]

        # create the actual work based on the mapped resource type
        model = Kernel.const_get(model_name)
        work = model.new(id: id)
        work.update(params)
        work.apply_depositor_metadata(depositor.user_key)
        work = Packager.add_manager_group(work, @campus)
        work.save

        work
      end

      #
      # Get files to upload
      # extracts file info for bitstream (optionally also thumnail) from METS and
      # creates UploadedFile objects for each
      #
      # @param pdf_file [String]  file to upload
      #
      # @return [Array<Hyrax::UploadedFile>]
      #
      def get_files_to_upload(pdf_file)
        @log.info 'Figuring out which files to upload'

        uploaded_files = []

        uploaded_file = upload_file(pdf_file)
        uploaded_files.push(uploaded_file) unless uploaded_file.nil?

        uploaded_files
      end

      # Upload file to Hyrax
      # uses the original file name instead of name given by aip package
      #
      # @param filename [String]  the file working directory
      #
      # @return Hyrax::UploadedFile
      #
      def upload_file(filename)
        @log.info 'uploading filename ' + filename

        return unless File.file?(filename)

        @log.info 'Uploading file ' + filename
        file = File.open(filename)

        uploaded_file = Hyrax::UploadedFile.create(file: file)
        uploaded_file.save

        file.close

        uploaded_file
      end

      #
      # Map creator notes to field type
      #
      # @param data [String]  creator field value
      # @param params [Hash]  work parameters
      #
      def process_creator(data, params)
        ignore_tag = '(translator)'
        creator_tags = {
          '(creator)' => 'creator',
          '(author)' => 'creator',
          '(editor)' => 'editor',
          '(publisher)' => 'publisher',
          '(home campus)' => 'granting_institution',
          '(thesis advisor)' => 'advisor',
          '(thesis committee member)' => 'committee_member'
        }
        data_lc = data.downcase
        return if data_lc.end_with? ignore_tag

        creator_tags.each do |key, value|
          next unless data_lc.end_with? key

          new_data = data[0, data.length - key.length].strip
          params[value] << new_data unless new_data.empty? || new_data == ','
          return nil
        end

        # default to creator if no ending tag is found
        params['creator'] << data
      end

      def process_identifier(data, params)
        data_lc = data.downcase
        if data_lc.start_with?('islandora')
          params['description_note'] << data.squish
        elsif data_lc.start_with?('http')
          params['related_url'] << data.squish
        else
          params['identifier'] << data.squish
        end
      end

      #
      # Extract data from XML based on config data mapping
      #
      # @param dom [Nokogiri::XML::Document]  DOMDocument of METS file
      #
      # @return Hash
      #
      def collect_params(dom)
        desc_metadata_prefix = '//oai_dc:dc'
        namespace = {
          oai_dc: 'http://www.openarchives.org/OAI/2.0/oai_dc/',
          dc: 'http://purl.org/dc/elements/1.1/'
        }

        params = Hash.new { |h, k| h[k] = [] }

        @config['fields'].each do |field|
          field_name = field[0]
          field_definition = field[1]
          next unless field_definition.include? 'xpath'

          # definition checks
          if field_definition['xpath'].nil?
            raise '"' + field_name + '" defined with empty xpath'
          end

          if field_definition['type'].nil?
            raise '"' + field_name + '" missing type'
          end

          field_definition['xpath'].each do |current_xpath|
            metadata = dom.xpath(desc_metadata_prefix + current_xpath, namespace)
            unless metadata.empty?
              if field_definition['type'].include? 'Array'
                metadata.each do |node|
                  node_text = node.text.squish
                  # ignore empty data or resource_type of value 'text'
                  next if node_text.nil?
                  next if node_text.empty?
                  next if field_name == 'resource_type' && node_text.casecmp('TEXT').zero?

                  if %w[creator contributor].include? field_name
                    process_creator(node_text, params)
                  elsif field_name == 'identifier'
                    process_identifier(node_text, params)
                  else
                    params[field_name] << node_text
                  end
                end
              else
                params[field_name] = metadata.text.squish
              end
            end
          end
        end

        params
      end

      #
      # Create a directory
      # only if it doesn't already exist
      #
      # @param dir [String]
      #
      # @return [String] the new directory
      #
      def initialize_directory(dir)
        Dir.mkdir(dir) unless Dir.exist?(dir)
        dir
      end
    end
  end
end
