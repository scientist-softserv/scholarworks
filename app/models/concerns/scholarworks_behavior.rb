# frozen_string_literal: true
#
# Base behavior for shared metadata across all models
#
# See also ScholarWorksFields
#
module ScholarworksBehavior
  extend ActiveSupport::Concern

  included do

    def advisor
      OrderedStringHelper.deserialize(super)
    end

    def advisor=(values)
      super sanitize_n_serialize(values)
    end

    def committee_member
      OrderedStringHelper.deserialize(super)
    end

    def committee_member=(values)
      super sanitize_n_serialize(values)
    end

    def contributor
      OrderedStringHelper.deserialize(super)
    end

    def contributor=(values)
      super sanitize_n_serialize(values)
    end

    def creator
      OrderedStringHelper.deserialize(super)
    end

    def creator=(values)
      super sanitize_n_serialize(values)
    end

    def discipline=(values)
      saved_values = []
      values.each do |v|
        next if DisciplineService::DISCIPLINES[v].nil?

        saved_values << v
      end
      super saved_values.uniq
    end

    protected

    #
    # Set college from campus and department
    #
    def set_college
      return if campus.blank? || department.blank?

      colleges = []
      campus_slug = CampusService.get_slug_from_name(campus.first)
      college_service = CollegeService.new(campus_slug, model_name)

      department.each do |dept|
        college_service.get(dept).each do |college|
          colleges.append college
        end
      end

      self.college = colleges unless colleges.empty?
    end
  end
end
