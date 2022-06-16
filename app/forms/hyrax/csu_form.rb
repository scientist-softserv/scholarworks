module Hyrax
  class CsuForm < Hyrax::Forms::WorkForm
    # all fields
    self.terms += FieldService.all

    # blank the fields hyrax requires
    self.required_fields = []

    #
    # Message to display at top of form
    #
    # Only really implemented in campus-specific forms
    #
    def alert_msg
      ''
    end

    #
    # Form's hidden field
    #
    # @return [Array]
    #
    def secondary_terms
      [:internal_note]
    end
  end
end
