# frozen_string_literal: true

require 'colorize'
require 'rubygems'
require 'time'
require 'yaml'
require 'net/http'
require 'json'
require 'open-uri'

module CalState
  module Packager
    #
    # Zenodo migration
    #
    class Zenodo 
      #
      # New Zenodo packager
      #
      # @param campus [String]      campus slug
      #
      def initialize(campus)
        @campus = campus

        # config and loggers
        config_file = 'config/packager/zenodo.yml'
        @config = OpenStruct.new(YAML.load_file(config_file))
        @log = Packager::Log.new(@config['output_level'])

        raise 'Must set campus name in config' unless @config['campus']

        # set working directories
        @input_dir = @config['input_dir']
        @complete_dir = initialize_directory(@input_dir + '_complete')
        @error_dir = initialize_directory(@input_dir + '_error')
        @log.info 'input dir ' + @input_dir
        @log.info 'complete dir ' + @complete_dir
        @log.info 'error_dir ' + @error_dir

        @log.info 'Starting rake task packager:zenodo'.green
        @log.info 'Campus: ' + @config['campus'].yellow
      end

      #
      # Process all items
      #
      def process_items(throttle)
        process_data(throttle)
      end

      protected

      #
      # Process all data from the query URI and input query parameter
      #
      # @param path [String]  path to directory
      #
      def process_data(throttle)
        return unless File.directory?(@input_dir)

        input_file = File.join(@input_dir, @config['input_file'])
        valid_input = File.file?(input_file) ? true : false

        if valid_input
          begin
            @log.info 'Using input file ' + input_file
            create_work_and_files(input_file, throttle)
          rescue StandardError => e
            @log.error e.class.to_s.red
            @log.error e
            raise e
          end
          File.delete(input_file)
        end
      end

      #
      # Create new work and attach any files
      #
      # @param dom [Nokogiri::XML::Document]  DOMDocument of METS file
      # @param data_file [String]             the file to upload
      #
      def create_work_and_files(input_file, throttle)
        start_time = DateTime.now

        depositor = User.find_by_user_key(@config['depositor'])
        raise 'User ' + @config['depositor'] + ' not found.' if depositor.nil?

        error_file = File.open(File.join(@error_dir, @config['input_file']), "w")
        complete_file = File.open(File.join(@complete_dir, @config['input_file']), "w")
        File.readlines(input_file).each do |line|
          line = line.strip
          next if line.empty?

          @log.error "input is [#{line}]" unless line.empty?
          @log.info 'Creating Hyrax work...'
          begin
            url = @config['query_url'].gsub("QUERY_PARAMETER", line)
            @log.info 'actual query [' + url + ']'

            # query for the json data
            uri = URI(url)
            response = Net::HTTP.get(uri)
            res_hash = JSON.parse(response)
            hits = res_hash['hits']['hits']
            hits.each do |hit|
              work = create_new_work(depositor, hit)
              uploaded_files = get_files_to_upload(hit['files'])
              AttachFilesToWorkJob.perform_now(work, uploaded_files)
              # Register work in handle
              HandleRegisterJob.perform_now(work)
            end
            complete_file.write line + "\n"
          #rescue JSON::ParserError
          rescue => e
            @log.error "Error with processing input data #{line}"
            @log.error e.to_s
            #@log.error e.inspect
            error_file.write line + "\n"
          end
          sleep(throttle.to_i) unless throttle.nil?
        end
        complete_file.close
        error_file.close

        # record the time it took
        end_time = Time.now.minus_with_coercion(start_time)
        total_time = Time.at(end_time.to_i.abs).utc.strftime('%H:%M:%S')
        @log.info 'Total time: ' + total_time
        @log.info 'DONE!'.green
      end

      #
      # process json data returned from zenodo API
      #
      # @param data [JSON object]  
      #
      # @return [ActiveFedora::Base] the work
      #
      def create_new_work(depositor, data)
        @log.info 'Configuring work attributes'
        params = Hash.new { |h, k| h[k] = [] }

        metadata = data['metadata']

        # figure out the model and type of work
        type = metadata['resource_type']['type']
        subtype = metadata['resource_type'].has_key?('subtype') ? metadata['resource_type']['subtype'] : 'default'
        @log.info "type [" + type + "] subtype [" + subtype + "]"
        model_resourcetype = @config['type_to_work_map'][type][subtype]
        model_resourcetype = model_resourcetype.split('_')
        model_name = model_resourcetype[0]
        raise 'No mapping for ' + type if model_name.blank?

        resource_type = model_resourcetype[1]
        @log.info "model name [" + model_name + "] resource_type [" + resource_type + "]"
        params['resource_type'] = [resource_type]

        params['visibility'] = (metadata.has_key?('access_right')) ? @config['access_right'][metadata['access_right']] : 'open'
        @log.info "Visibility [" + params['visibility'] + "]"

        process_direct_map_fields(@config['direct_map_fields'], metadata, params)
        process_hash_map_fields(@config['hash_map_fields'], metadata, params)
        process_hash_array_map_fields(@config['hash_array_map_fields'], metadata, params)
        # model specific metadata
        process_hash_map_fields(@config['work_specific_hash_map_fields'][model_name], metadata, params) if @config['work_specific_hash_map_fields'].has_key?(model_name)

        person_fields = @config['person_fields']
        person_fields.each do |key, value|
          process_composite_person(metadata, key, value, params)
        end          
        process_composite_person(metadata['thesis'], 'supervisors', 'advisor', params) if metadata.has_key?('thesis') && model_name.eql?('Thesis')

        params['campus'] = [@config['campus']]
        
        # set admin set to deposit into
        params['admin_set_id'] = @config['admin_set_id'] unless @config['admin_set_id'].nil?

        #@log.info ""
        #@log.info params.inspect

        # set noid
        id = Noid::Rails::Service.new.minter.mint

        @log.info 'Creating a new ' + resource_type + ' with id:' + id

        # create the actual work based on the mapped resource type
        model = Kernel.const_get(model_name)
        work = model.new(id: id)
        work.update(params)
        work.apply_depositor_metadata(depositor.user_key)
        work = Packager.add_manager_group(work, @campus)
        work.save

        work
      end

      def process_direct_map_fields(fields, data, params)
        fields.each do |key, value|
          p "process_direct_map_fields key #{key} value [#{value}]"
          next unless data.has_key?(key) && !data[key].empty?

          @log.info "process_direct_map_fields: zonedo field [" + key + "] map to scholarworks field [" + value + "]"
          if data[key].is_a?(Array)
            params[value] = data[key]
          else
            params[value] = [data[key]]
          end
        end
      end

      def process_hash_map_fields(fields, data, params)
        fields.each do |outer_key, outer_value|
          @log.info "process_hash_map_fields outer_key [" + outer_key + "] outer_value " + outer_value.inspect
          next unless data.has_key?(outer_key)

          outer_value.each do |inner_key, inner_value|
            next unless data[outer_key].has_key?(inner_key) && !data[outer_key][inner_key].empty?

            @log.info "process_hash_map_fields: zonedo field [" + outer_key + ":" + inner_key + "] map to scholarworks field [" + inner_value + "]"
            params[inner_value] = [data[outer_key][inner_key]]
          end
        end
      end

      def process_hash_array_map_fields(fields, data, params)
        fields.each do |outer_key, outer_value|
          outer_value.each do |inner_key, inner_value|
            next unless data.has_key?(outer_key)

            params[inner_value] = []
            data[outer_key].each do |arr|
              next unless arr.has_key?(inner_key) && !arr[inner_key].empty?

              params[inner_value] << arr[inner_key]
            end
            @log.info "process_hash_array_map_fields: zonedo field [" + outer_key + ":" + inner_key + "] map to scholarworks field [" + inner_value + "]"
          end
        end
      end

      def process_composite_person(data, zenodo_field, work_field, params)
        return unless data.has_key?(zenodo_field)

        params[work_field] = []
        persons = data[zenodo_field]
        persons.each do |person|
          institution = person.has_key?('affiliation') ? person['affiliation'] : ''
          orcid = person.has_key?('orcid') ? person['orcid'] : ''
          composite_person = person['name'] + '::::::' + institution + ':::' + orcid
          @log.info "process_composite_person: zonedo field [" + zenodo_field + "] map to scholars field [" + work_field + "] name [" + person['name'] + "] institution [" + institution + "] orcid [" + orcid + "]"
          params[work_field] << composite_person
        end
      end

      #
      # Get files to upload
      # extracts file from URL
      # creates UploadedFile objects for each
      #
      # @param url_files array of urls of the location of the files
      #
      # @return [Array<Hyrax::UploadedFile>]
      #
      def get_files_to_upload(url_files)
        @log.info 'Harvest files to upload'

        uploaded_files = []
        url_files.each do |url_file|
          uploaded_file = upload_file(url_file)
          uploaded_files.push(uploaded_file) unless uploaded_file.nil?
        end

        uploaded_files
      end

      # Upload file to Hyrax
      #
      # @param file_link [URL location]
      #
      # @return Hyrax::UploadedFile
      #
      def upload_file(url_file)
        file_link = url_file['links']['self']
        file_name = url_file['key'].gsub(' ', '_')
        url = URI.parse(file_link)
        req = Net::HTTP.new(url.host, url.port)
        req.use_ssl = true
        res = req.request_head(url.path)
        return unless res.code.to_i == 200

        content = open(file_link)
        IO.copy_stream(content, @input_dir + '/' + file_name)

        @log.info 'Uploading file ' + file_name
        file = File.open(@input_dir + '/' + file_name)
        uploaded_file = Hyrax::UploadedFile.create(file: file)
        uploaded_file.save
        file.close
        File.delete(@input_dir + '/' + file_name)

        uploaded_file
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
