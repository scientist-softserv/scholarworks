# frozen_string_literal: true

#
# Base behavior for shared metadata across all models
#
# See also BasicFields
#
module BasicBehavior
  extend ActiveSupport::Concern

  included do

    before_create :on_create
    before_save :on_save

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

    protected

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
