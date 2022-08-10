# frozen_string_literal: true

#
# Colleges service
#
class CollegeService
  #
  # New campus service
  #
  # @param campus [String]  campus slug
  # @param model [String]   model name
  #
  def initialize(campus, model)
    model_slug = CalState::Metadata.get_slug(model)
    model_file = Rails.root.join("config/authorities/departments_#{campus}_#{model_slug}.yml")
    file = Rails.root.join("config/authorities/departments_#{campus}.yml")
    @yaml = if File.exist?(model_file)
              YAML.load_file(model_file)
            else
              YAML.load_file(file)
            end
  end

  #
  # Get college for department, if defined
  #
  # @param dept [String]  department name
  #
  # @return [Array]
  #
  def get(dept)
    colleges = []
    @yaml['terms'].each do |department|
      next unless department['term'] == dept
      next unless department.key?('college')

      college = department['college']
      college = [college] unless college.is_a?(Array)
      college.each do |coll|
        colleges.append coll
      end
    end

    colleges
  end
end
