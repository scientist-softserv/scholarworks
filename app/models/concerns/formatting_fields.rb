# frozen_string_literal: true
#
# Fields for formatted title and description
#
module FormattingFields
  extend ActiveSupport::Concern

  included do

    property :description_formatted, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#descriptionFormatted') do |index|
      index.as :displayable
    end

    property :title_formatted, predicate: ::RDF::URI.new('http://library.calstate.edu/scholarworks/ns#titleFormatted') do |index|
      index.as :displayable
    end
  end
end
