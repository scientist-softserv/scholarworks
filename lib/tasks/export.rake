# frozen_string_literal: true

require 'pp'

namespace :calstate do
  desc 'Export metadata csv for a campus'
  task :export, %i[campus] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus provided.'

    %w[Thesis Publication Dataset EducationalResource].each do |model_name|
      model = Kernel.const_get(model_name)

      # add these fields to the front of the array so we can
      # handle them differently (see below as to why)
      column_names = %w[id campus admin_set_id visibility embargo_release_date
                        visibility_during_embargo visibility_after_embargo]

      # attributes from fedora
      attribute_names = get_columns(model.attribute_names)
      column_names.push(*attribute_names)

      csv_file = '/home/ec2-user/exported/' +
                 campus + '-' + model_name.downcase + '.csv'

      CSV.open(csv_file, 'wb') do |csv|
        csv << column_names
        model.where(campus: campus).each do |doc|
          begin
            values = [doc.id.to_s, # not in attributes
                      doc.campus.first.to_s, # move to front
                      doc.admin_set_id.to_s, # move to front
                      doc.visibility.to_s, # not in attributes
                      doc.embargo_release_date.to_s, # not in attributes
                      doc.visibility_during_embargo.to_s, # not in attributes
                      doc.visibility_after_embargo.to_s] # not in attributes
            values.push(*get_attr_values(doc.attributes, attribute_names))
            csv << values
          rescue StandardError => e
            puts 'ERROR:' + e.to_s
          end
        end
      end
    end
  end

  # Determine the columns to include in the export
  #
  # @param column_names [Array]  all the attribute names from the Fedora model
  # @return [Array]              only the approved columns
  #
  def get_columns(column_names)
    # remove internal fedora fields
    # also campus & admin_set_id, since we will prepend those
    columns_remove = %w[head tail arkivo_checksum owner access_control_id state
                        representative_id thumbnail_id rendering_ids embargo_id
                        lease_id source relative_path import_url
                        campus admin_set_id]
    column_names - columns_remove
  end

  # Extract the values from this record
  #
  # @param attributes [Hash]        all the attributes from the Fedora record
  # @param attribute_names [Array]  the attributes we want to extract
  # @return [Array]                 extracted values
  #
  def get_attr_values(attributes, attribute_names)
    values = []
    attributes.each do |key, value|
      next unless attribute_names.include?(key)

      # if this is a multi-valued field, join them using pipe
      if value.is_a?(ActiveTriples::Relation)
        values << value.join('|')
      else
        values << value.to_s
      end
    end
    values
  end
end
