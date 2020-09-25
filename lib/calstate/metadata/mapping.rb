# frozen_string_literal: true

module CalState
  module Metadata
    #
    # Shared metadata mapping functions
    #
    module Mapping
      def url_mapping
        {
          theses: 'Thesis',
          publications: 'Publication',
          datasets: 'Dataset',
          educational_resources: 'EducationalResource'
        }
      end
    end
  end
end
