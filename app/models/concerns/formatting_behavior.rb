# frozen_string_literal: true

#
# Methods for setting and getting formatted fields (title and description)
#
module FormattingBehavior
  extend ActiveSupport::Concern

  included do

    #
    # Set description
    #
    # Sets `description_formatted` with (allowed) HTML-formatted values and
    # `description` with no formatting.
    #
    # @param values [Array]
    #
    def description=(values)
      self.description_formatted = HtmlHelper.clean_values(values, %w[p em ol ul li])
      super(HtmlHelper.clean_values(values))
    end

    #
    # Description with any HTML formatting
    #
    # For description with no formatting use `description`
    #
    # @return [Array]
    #
    def description_formatted
      return description if super.blank?

      super
    end

    #
    # All (formatted) description fields combined into single value
    #
    # @return [String]
    #
    def descriptions
      combined_val = String.new
      description_formatted.each do |d|
        combined_val << d
      end
      combined_val
    end

    #
    # Set title
    #
    # Sets `title_formatted` with (allowed) HTML-formatted values and
    # `title` with no formatting.
    #
    # @param values [Array]
    #
    def title=(values)
      self.title_formatted = HtmlHelper.clean_values(values, %w[em])
      super(HtmlHelper.clean_values(values))
    end

    #
    # Title with any HTML formatting
    #
    # For title with no formatting use `title`
    #
    # @return [Array]
    #
    def title_formatted
      return title if super.blank?

      super
    end

    #
    # All (formatted) titles together in a single value
    #
    # @return [String]
    #
    def titles
      combined_val = String.new
      title_formatted.each do |d|
        combined_val << d
      end
      combined_val
    end
  end
end
