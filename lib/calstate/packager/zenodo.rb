# frozen_string_literal: true

require 'active_support/core_ext'

module CalState
  module Packager
    #
    # Zenodo migration
    #
    class Zenodo < AbstractPackager
      #
      # New Zenodo packager
      #
      # @param admin_set [String]  admin set ID
      # @param campus [String]     campus slug
      # @param depositor [String]  depositor
      #
      def initialize(admin_set, campus, depositor)
        super admin_set, campus, depositor

        @query_url = 'https://zenodo.org/api/records/?q=doi:"QUERY_PARAMETER"'
        @xslt = "#{Rails.root}/config/mappings/zenodo.xslt"
        @default_resource_type = @config['default_type']
      end

      #
      # Process all items
      #
      def process_items
        return unless File.directory?(@input_dir)

        input_file = File.join(@input_dir, @config['input_file'])
        valid_input = File.file?(input_file) ? true : false
        return unless valid_input

        @log.info "Using input file #{input_file}"
        create_work_and_files(input_file)
      end

      protected

      #
      # Create new work and attach any files
      #
      # @param input_file [String]  path to file of zenodo id's
      #
      def create_work_and_files(input_file)
        File.readlines(input_file).each do |id|
          id.strip!
          next if id.empty?
          next if work_already_exists?(id)

          hits = get_record(id)
          hits.each do |hit|
            # no files, no mas
            unless hit['files'].is_a?(Array)
              File.write("#{@input_dir}/embargoed.txt", "#{id}\n", mode: 'a')
              next
            end

            # convert to xml
            to_xml = hit['metadata'].to_xml(root: 'record')
            xml = Nokogiri::XML(to_xml.to_s)

            # then to params
            doc = transform_xml(xml, @xslt)
            uploaded_files = get_files_to_upload(hit['files'])
            params = FieldService.xml_to_params(doc.root)

            unless @default_resource_type.empty?
              if params['resource_type'].first == 'Other' || params['resource_type'].empty?
                params['resource_type'] = [@default_resource_type]
              end
            end

            # process it
            process_item(params, uploaded_files)
          end
        end
      end

      #
      # Get files to upload
      #
      # @param url_files [Array]  array of urls of the location of the files
      #
      # @return [Array<Hyrax::UploadedFile>]
      #
      def get_files_to_upload(url_files)
        @log.info 'Fetching files from Zenodo:'

        uploaded_files = []
        url_files.each do |url_file|
          uploaded_file = upload_file(url_file)
          uploaded_files.push(uploaded_file) unless uploaded_file.nil?
        end

        uploaded_files
      end

      # Upload file to Hyrax
      #
      # @param url_file [String]   URL to file
      #
      # @return [Hyrax::UploadedFile]
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
        IO.copy_stream(content, "#{@input_dir}/#{file_name}")

        @log.info "Fetching file `#{file_name}`"
        file = File.open("#{@input_dir}/#{file_name}")
        uploaded_file = Hyrax::UploadedFile.create(file: file)
        uploaded_file.save
        file.close
        File.delete("#{@input_dir}/#{file_name}")

        uploaded_file
      end

      #
      # Check to see if we have work with such DOI in the system
      #
      # @param id [String]  Zenodo DOI
      #
      # @return [Boolean]
      #
      def work_already_exists?(id)
        query = { Solrizer.solr_name('doi') => id }
        work = ActiveFedora::Base.where(query)

        return false if work.blank?

        @log.info "Work with DOI '#{id}' is already in the system."
        true
      end

      #
      # Fetch the metadata record from Zenodo
      #
      # @param id [String]  DOI
      #
      # @return [Array<Hash>]
      #
      def get_record(id)
        url = @query_url.gsub('QUERY_PARAMETER', id)
        @log.info "Query:[#{url}]"
        uri = URI(url)
        response = Net::HTTP.get(uri)
        res_hash = JSON.parse(response)

        return [{}] unless res_hash.is_a?(Hash)
        return [{}] unless res_hash['hits'].is_a?(Hash)

        res_hash['hits']['hits']
      end
    end
  end
end
