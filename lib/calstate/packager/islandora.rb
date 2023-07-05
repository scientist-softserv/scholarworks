# frozen_string_literal: true

module CalState
  module Packager
    #
    # Islandora importer
    #
    class Islandora < AbstractPackager
      #
      # New Islandora packager
      #
      # @param admin_set [String]  admin set ID
      # @param campus [String]     campus slug
      # @param depositor [String]  depositor
      #
      def initialize(admin_set, campus, depositor)
        super admin_set, campus, depositor

        @type = type
        @visibility = @config['visibility'] ||= 'open'

        raise 'Must set metadata_file in config' unless @config['metadata_file']
        raise 'Must set data_file in config' unless @config['data_file']

        @log.info 'Campus: ' + @campus.yellow
        @log.info 'Work type ' + @type
        @log.info 'Visibility ' + @visibility

        # set working directories
        @complete_dir = initialize_directory(@input_dir + '_complete')
        @error_dir = initialize_directory(@input_dir + '_error')
      end

      #
      # Process all items
      #
      def process_items
        Dir.each_child(@input_dir) do |dirname|
          @log.info "\n\nProcessing " + dirname
          process_dir(dirname)
        end
      end

      #
      # Process all packages in a directory
      #
      # @param path [String]  path to directory
      #
      def process_dir(path)
        return unless File.directory?(File.join(@input_dir, path))

        # process subdirectories
        Dir.each_child(File.join(@input_dir, path)) do |subdir|
          process_dir(path + '/' + subdir)
        end

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

        unless valid_metadata
          cleanup(path, File.join(@error_dir, path))
          return
        end

        data_file = nil
        data_files = @config['data_file'].split('|')

        # TODO: process all files
        data_files.each do |fileext|
          Dir.glob(@input_dir + '/' + path + '/*.' + fileext) do |filename|
            data_file = filename
            break
          end
          next if data_file.nil?

          @log.info 'Using metadata file ' + metadata_file
          @log.info 'Using data file ' + data_file
          prepare_item(path, metadata_file, data_file)
        end
      end

      #
      # Rename the folders to islandora_id
      #
      # otherwise the folders are named with the title of the work (weird)
      #
      # @param folder [String]  [optional] the folder containing the works
      #                         will use config input_dir if left nil
      #
      def rename_folders(folder = nil)
        folder = @input_dir if folder.nil?
        Dir.each_child(folder) do |file|
          m = file.match(/\(islandora:([0-9]*)\)/)
          unless m.nil?
            FileUtils.mv(folder + '/' + file,
                         folder + '/' + 'islandora_' + m[1])
          end
        end
      end

      protected

      #
      # Process the DC Record file in a directory
      #
      # creates new work(s) based on content
      #
      # @param dir_name [String]       the directory of the extracted package
      # @param metadata_file [String]  location of metadata file
      # @param data_file [String]      the file to upload
      #
      def prepare_item(dir_name, metadata_file, data_file)
        @log.info 'Processing metadata file:' + metadata_file

        # make sure we actually have a metadata file
        unless File.exist?(metadata_file)
          raise 'No metadata file found in ' + dir_name
        end

        # parse it
        dom = Nokogiri::XML(File.open(metadata_file))

        params = prepare_params(dom)
        files = []
        files = [data_file] unless @metadata_only

        process_item(params, files, item_dir: dir_name)
      end

      #
      # What to do on error
      #
      # @param error [StandardError]  the error
      # @param params [Hash]          record attributes
      # @param files [Array]          file locations
      # @param args                   other args to pass to error processing
      #
      def on_error(error, params, files, **args)
        done_dir = File.join(@error_dir, args[:item_dir])
        cleanup(path, done_dir)
      end

      #
      # What to do on success
      #
      # @param params [Hash]  record attributes
      # @param files [Array]  file locations
      # @param args           other args to pass to error processing
      #
      def on_success(params, files, **args)
        done_dir = File.join(@complete_dir, args[:item_dir])
        cleanup(path, done_dir)
      end

      #
      # Prepare record parameters
      #
      # @param dom [Nokogiri::XML::Document]  DOMDocument of METS file
      #
      # @return Hash
      #
      def prepare_params(dom)
        params = collect_params(dom)
        params['visibility'] = @visibility
        params
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

      #
      # Process identifiers and URLs
      #
      # @param data [String]  identifier field value
      # @param params [Hash]  work parameters
      #
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
    end
  end
end
