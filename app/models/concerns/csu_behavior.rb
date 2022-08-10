# frozen_string_literal: true

#
# Base behavior for shared metadata across all models
#
# See also CsuFields
#
module CsuBehavior
  extend ActiveSupport::Concern

  included do

    before_create :on_create
    before_save :on_save

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

    #
    # Assign campus name
    #
    # @param campus [String|Array]  name(s) to assign to campus
    #
    def assign_campus(campus)
      campuses = if campus.is_a?(Array)
                   campus
                 else
                   [campus]
                 end
      correct_names = []
      campuses.each do |name|
        CampusService.ensure_campus_name(name)
        correct_names.append name
      end
      self.campus = correct_names
    end

    #
    # Set values the first time the record is created
    #
    def on_create
      raise 'No admin set defined for this item.' if admin_set&.title&.first.nil?

      assign_campus(admin_set.title.first.to_s)
    end

    #
    # Before saving this work
    #
    def on_save
      set_year
      set_college
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

      self.college = colleges
    end

    #
    # Set year for work
    #
    def set_year
      year = if self.date_issued.count.zero?
               self.date_uploaded
             else
               self.date_issued.first
             end
      self.date_issued_year = extract_year(year)
    end

    #
    # Extract four-digit year from date issued, for facet
    #
    # @param date_issued [String]
    #
    # @return [String]
    #
    def extract_year(date_issued)
      # no date, no mas
      return nil if date_issued.nil?

      # make sure this is a string
      date_issued = date_issued.to_s

      # found four-digit year, cool
      match = /1[89][0-9]{2}|2[01][0-9]{2}/.match(date_issued)
      return match[0] unless match.nil?

      # date in another format, use chronic
      date = Chronic.parse(date_issued, context: 'past')
      now = Date.today
      format = '%Y-%m-%d'

      # chronic didn't find a date
      return nil if date.nil?

      # chronic returned current date, so a miss
      return nil if date.strftime(format) == now.strftime(format)

      # year way out of range, likely a typo
      year = date.year
      return nil if year < 1900 || year > (Date.today.year + 5)

      year.to_s # actual extracted year!
    end

    #
    # Sanitize and serialize person data
    #
    def sanitize_n_serialize(values)
      full_sanitizer = Rails::Html::FullSanitizer.new
      sanitized_values = Array.new(values.size, '')
      values.each_with_index do |v, i|
        sanitized_values[i] = full_sanitizer.sanitize(v) unless v == '|||'
      end
      OrderedStringHelper.serialize(sanitized_values)
    end
  end
end
