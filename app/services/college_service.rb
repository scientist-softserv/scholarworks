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
