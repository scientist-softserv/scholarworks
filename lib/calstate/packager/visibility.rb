# frozen_string_literal: true

module CalState
  module Packager
    #
    # CSV importer
    #
    class Visibility < Csv
      #
      # Process an item
      #
      # @param params [Hash]  record attributes
      # @param files [Array]  file locations
      # @param args           other args to pass to error handling
      #
      def process_item(params, files, **args)
        work = ActiveFedora::Base.find(params['id'])
        update_visibility(work, params['work_visibility'], params['file_visibility'])
      end
    end
  end
end
