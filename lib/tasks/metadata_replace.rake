# Usage
# bundle exec rake calstate:metadata_replace["San Francisco",test.csv,"thesis|dataset"]
# bundle exec rake calstate:metadata_replace["San Francisco",test.csv,"theis"]
# bundle exec rake calstate:metadata_replace["San Francisco",test.csv]
#
# campus and input_file are required fields where model_type is optional. All four
# models (Thesis, Publication, Dataset, EducationalResource] will be used if model_type
# is not provided and model_type is not case sensitive.
#
# input spreadsheet should have the following format where each row consists of:
# field_name    field_value_to_look_for   field_value_to_replace
#
# field_name is like resource_type or any of the field for the model. It will ignore
# it if the field name doesn't exist.
# field_value_to_look_for would be the string value such as "Master Thesis" or "thesis", it's case sensitive
# it will only do the replacement if it iterates through all the values and found the value.
# field_value_to_replace is the value we want to replace; notice that if it's empty then it basically
# get rid of the field_value_to_look_for.
#
require 'pp'
require 'csv'

namespace :calstate do
  desc 'Metadata replace'
  task :metadata_replace, %i[campus input_file model_type] => [:environment] do |_t, args|
    # using || instead of or would not work
    campus_name = args[:campus] or raise 'No campus name provided'
    input_file = args[:input_file] or raise 'No input file provided.'
    model_str = args[:model_type]

    model_types = get_model_types(model_str)
    p "Input file: #{input_file}"
    p "Model types: #{model_types}"
    metadata = load_csv_file(input_file)
    raise "No metadata to replace" if metadata.empty?

    replace_metadata(campus_name, model_types, metadata)
  end

  # Figure out what type of work we need to process
  def get_model_types(model_type)
    return [Thesis, Publication, Dataset, EducationalResource] if model_type.nil? or model_type.length() == 0

    model_types = []
    types = model_type.split('|')
    types.each do |type|
      case type.downcase
      when 'thesis'
        model_types << Thesis
      when 'publication'
        model_types << Publication
      when 'educationalresource'
        model_types << EducationalResource
      when 'dataset'
        model_types << DataSet
      end
    end
    model_types = [Thesis, Publication, Dataset, EducationalResource] if model_types.length() == 0
    model_types
  end

  # load the input spreadsheet and figure out fiel name, field value to find to
  # replace and field value to replace to
  def load_csv_file(csv_file)
    metadata = []
    CSV.foreach(csv_file) do |row|
      next if row.length < 2

      value = {}
      value['field'] = row[0]
      value['look_for'] = row[1]
      value['to_replace'] = row[2]
      metadata << value
    end

    metadata
  end

  def replace_metadata(campus_name, model_types, metadata)
    model_types.each do |model|
      model.where(campus: campus_name).each do |doc|
        need_update = false
        metadata.each do |m|
          begin
            found = false
            field_name = m['field']
            field_values = doc[field_name].dup # throw ArgumentError if not such field_name

            # do the replacment or get rid of
            replace_field_values = []
            field_values.each do |field_value|
              next if field_value.nil? or field_value.empty?

              field_value = clean_field(field_value)
              if field_value.eql?(m['look_for']) && !m['to_replace'].nil? && !m['to_replace'].empty?
                found = true
                need_update = true
                replace_field_values << m['to_replace']
              else
                replace_field_values << field_value
              end
            end
            doc[field_name] = replace_field_values if found
          rescue ArgumentError => e
            p e.message
          end
        end

        doc.save if need_update
      end
    end
  end
end
