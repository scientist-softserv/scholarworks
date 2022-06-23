# frozen_string_literal: true

#
# Degree level authority
#
class DegreeLevelService
  #
  # New degree level service
  #
  # @param model [String]  model, lowercase
  #
  def initialize(model)
    types_file = "config/authorities/resource_types_#{model}.yml"
    @yaml = YAML.load_file(Rails.root.join(types_file))
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
