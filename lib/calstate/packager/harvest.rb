# frozen_string_literal: true

require 'httparty'
require 'nokogiri'
require 'date'

module CalState
  module Packager
    #
    # OAI-PMH harvest
    #
    class Harvest < AbstractPackager
      #
      # New Harvest packager
      #
      # @param admin_set [String]  admin set ID
      # @param campus [String]     campus slug
      # @param depositor [String]  depositor
      #
      def initialize(admin_set, campus, depositor)
        super admin_set, campus, depositor

        @metadata_only = true
        @fix_params = true
        @default_type = 'Publication'
        @xslt = "#{Rails.root}/config/packager/xslt/#{campus}.xslt"

        # processing directories
        @output_dir = @config['output_dir']
        initialize_directory(@output_dir)
      end

      #
      # Process all items
      #
      # @param from [String]   date from which to harvest the records
      #
      def process_items(from)
        @log.info 'Starting rake task packager:harvest'.green
        @log.info 'Output dir: ' + @output_dir
        @log.info 'URL: ' + @config['url']
        @log.info 'Campus: ' + @campus

        keep_going = true
        resumption_token = nil

        while keep_going
          response = fetch_batch(from, resumption_token)
          file = @output_dir + '/response-' + Time.now.to_i.to_s + '.xml'
          File.write(file, response.to_xml)

          doc = transform_xml(response, @xslt)
          doc.xpath('//record').each do |record|
            params = collect_params(record)
            next if params['title'].blank?

            if params['action']&.first == 'skip'
              @log.warn 'Skipping record ' + params['external_id']
              next
            end

            if params['action']&.first == 'delete'
              delete_work('external_id_tesim', params['external_id'])
              next
            end

            process_item(params, [])
          end

          resumption_token = get_resumption_token(response)
          keep_going = false if resumption_token.blank?
        end
      end

      protected

      def on_create(params, files, **args)
        create_or_update_work(params, 'external_id_tesim', params['external_id'] )
      end

      def on_error(error, record, files, **args)
        @log.error error.message
      end

      #
      # Get the params for the record
      #
      # @param record [Nokogiri::XML]
      #
      # @return [Hash]
      #
      def collect_params(record)
        params = FieldService.xml_to_params(record)
        params['external_system'] = @config['external_system']

        unless params['date_issued'].blank?
          params['date_issued'] = format_dates(params['date_issued'])
        end

        params
      end

      #
      # Extract resumptionToken from OAI-PMH response
      #
      # @param response [Nokogiri::XML::Document]
      #
      # @return [String]
      #
      def get_resumption_token(response)
        namespaces = { oai: 'http://www.openarchives.org/OAI/2.0/' }
        response.xpath('//oai:resumptionToken', namespaces).each do |token|
          return token.text
        end

        ''
      end

      #
      # Fetch a batch of records
      #
      # @param from [String]              [optional] date to harvest from
      # @param resumption_token [String]  [optional] resumption token
      #
      # @return [Nokogiri::XML::Document]
      #
      def fetch_batch(from = nil, resumption_token = nil)
        url = @config['url'] + '?verb=ListRecords'

        if resumption_token.blank?
          url += '&set=' + @config['set'] +
                 '&metadataPrefix=' + @config['metadataPrefix']
          url += '&from=' + CGI.escape(from) unless from.blank?
        else
          url += '&resumptionToken=' + CGI.escape(resumption_token)
        end

        @log.info "url [#{url}]"
        @log.info "\n\n"

        response = HTTParty.get(url)
        Nokogiri::XML(response.body)
      end
    end
  end
end
