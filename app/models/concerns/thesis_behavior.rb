# frozen_string_literal: true
#
# Shared behavior for Thesis & Project
#
# See also ThesisFields
#
module ThesisBehavior
  extend ActiveSupport::Concern

  included do
    #
    # Before saving this work
    #
    def on_save
      set_year
      set_college
      set_degree_level
      set_campus_publisher
    end

    #
    # Set the degree level based on the resource type
    #
    def set_degree_level
      service = DegreeLevelService.new(self.class.name.downcase, campus.first)
      level = service.get(resource_type.first)
      self.degree_level = level unless level.nil?
    end

    #
    # Make the campus the publisher
    #
    def set_campus_publisher
      full_name = CampusService.get_full_from_name(campus.first)
      self.publisher = [full_name]
    end

  end
end
