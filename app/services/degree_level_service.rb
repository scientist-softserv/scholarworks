# frozen_string_literal: true

#
# Degree level authority
#
class DegreeLevelService
  #
  # New degree level service
  #
  # @param model [String]        model name lowercase
  # @param campus_name [String]  campus name
  #
  def initialize(model, campus_name)
    campus = CampusService.get_slug_from_name(campus_name)
    types_file  = Rails.root.join("config/authorities/resource_types_#{model}.yml")
    campus_file = Rails.root.join("config/authorities/resource_types_#{model}_#{campus}.yml")
    @yaml = if File.exist?(campus_file)
              YAML.load_file(campus_file)
            else
              YAML.load_file(types_file)
            end
  end

  #
  # Get degree level from resource type, if defined
  #
  # @param resource_type [String]  resource type
  #
  # @return [String|nil]
  #
  def get(resource_type)
    @yaml['terms'].each do |type|
      next unless type['term'] == resource_type
      next unless type.key?('degree_level')

      return type['degree_level']
    end

    nil
  end
end
