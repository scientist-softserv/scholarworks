# frozen_string_literal: true

# Usage
# bundle exec rake calstate:metadata_replace[sanfrancisco,test.csv,"thesis|dataset"]
# bundle exec rake calstate:metadata_replace[sanfrancisco,test.csv,"theis"]
# bundle exec rake calstate:metadata_replace[sanfrancisco,test.csv]
#
# campus and input_file are required fields where model_type is optional.
# All existing models will be used if model_type is not provided
#
# input spreadsheet should have the following format where each row consists of:
# field_name    field_value_to_look_for   field_value_to_replace

require 'calstate/metadata'

namespace :calstate do
  desc 'Metadata replace'
  task :metadata_replace, %i[campus input_file model] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus name provided'
    input_file = args[:input_file] or raise 'No input file provided.'
    model = args[:model]

    p "Input file: #{input_file}"
    p "Model types: #{model}"

    fixer = CalState::Metadata::Csv::Fixer.new(campus, model)
    fixer.replace_metadata(input_file)
  end
end
