# frozen_string_literal: true

module CalState
  module Packager
    #
    # CSV importer
    #
    class Visibility < Csv

      def initialize(campus)
        super(campus)

        # ignore campus config
        @metadata_only = true
        @config = {}
      end

      #
      # Process an item
      #
      # @param params [Hash]  record attributes
      # @param files [Array]  file locations
      # @param args           other args to pass to error handling
      #
      def process_item(params, files, **args)
        id = params['id']
        work_visibility = params['work_visibility'].nil? ? nil : params['work_visibility'].first
        file_visibility = params['file_visibility'].nil? ? nil : params['file_visibility'].first

        @log.info "Updating visibility for work `#{id}` to `#{work_visibility}` and files `#{file_visibility}`"

        work = ActiveFedora::Base.find(id)
        update_visibility(work, work_visibility, file_visibility)
      end
    end
  end
end
