# frozen_string_literal: true

require 'csv'
require 'pp'

namespace :calstate do
  desc 'Export metadata csv for a campus'
  task :export, %i[campus] => [:environment] do |_t, args|
    # campus name
    campus = args[:campus] or raise 'No campus provided.'
    campus_name = Hyrax::CampusService.get_campus_name_from_id(campus)

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
        csv.to_io.write "\uFEFF" # BOM forces excel to treat the file as UTF-8
        csv << column_names
        model.where(campus: campus_name).each do |doc|
          begin
            values = [prep_value(doc.id), # not in attributes
                      prep_value(doc.campus.first), # move to front
                      prep_value(doc.admin_set_id), # move to front
                      prep_value(doc.visibility), # not in attributes
                      prep_value(doc.embargo_release_date), # not in attributes
                      prep_value(doc.visibility_during_embargo), # not in attributes
                      prep_value(doc.visibility_after_embargo)] # not in attributes
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
  # @param column_names [Array]  all the attribute names from the fedora model
  # @return [Array] only the approved columns
  #
  def get_columns(column_names)
    # remove internal fedora fields
    columns_remove = %w[head tail arkivo_checksum owner access_control_id state
                        representative_id thumbnail_id rendering_ids embargo_id
                        lease_id relative_path import_url]
    # remove scholarworks utility fields
    columns_remove += %w[resource_type_thesis resource_type_educationalresource
                         resource_type_dataset resource_type_publication]
    # remove columns we want to shift to the front, and will handle separately
    columns_remove += %w[campus admin_set_id]
    column_names - columns_remove
  end

  # Extract the values from this record
  #
  # @param attributes [Hash]        all the attributes from the fedora record
  # @param attribute_names [Array]  the attributes we want to extract
  # @return [Array] extracted values
  #
  def get_attr_values(attributes, attribute_names)
    values = []
    attributes.each do |key, value|
      next unless attribute_names.include?(key)

      # if this is a multi-valued field, join them using pipe
      if value.is_a?(ActiveTriples::Relation)
        values << prep_value(value.join('|'))
      else
        values << prep_value(value)
      end
    end
    values
  end

  # convert value to string and append a tab to the end to force excel
  # to treat the field as text rather than a number or date
  #
  # @param value [String]  the value to add
  # @return [String] the value plus tab at the end
  #
  def prep_value(value)
    value.to_s + "\t"
  end
end
