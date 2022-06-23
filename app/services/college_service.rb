# frozen_string_literal: true

#
# Colleges service
#
class CollegeService
  #
  # New campus service
  #
  # @param campus [String]  campus slug
  #
  def initialize(campus)
    dept_file = "config/authorities/departments_#{campus}.yml"
    @yaml = YAML.load_file(Rails.root.join(dept_file))
  end

  #
  # Get college for department, if defined
  #
  # @param dept [String]  department name
  #
  # @return [String|nil]
  #
  def get(dept)
    @yaml['terms'].each do |department|
      next unless department['term'] == dept
      next unless department.key?('college')

      return department['college']
    end

    nil
  end
end
