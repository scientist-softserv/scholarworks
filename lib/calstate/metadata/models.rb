# frozen_string_literal: true

module CalState
  module Metadata
    #
    # Models
    #
    class Models
      include Mapping
      #
      # The models defined in ScholarWorks
      #
      # @return [Array]  of model classes
      #
      def all
        final = []
        model_names.each do |model_name|
          final.append Kernel.const_get(model_name)
        end
        final
      end
    end
  end
end


