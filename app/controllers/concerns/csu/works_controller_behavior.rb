
module Csu
  module WorksControllerBehavior
    extend ActiveSupport::Concern

    #
    # Build a campus-specific form, if it exists
    #
    def build_form
      campus = current_user.campus
      @form = WorkFormService.build(campus, curation_concern, current_ability, self)
    end
  end
end
