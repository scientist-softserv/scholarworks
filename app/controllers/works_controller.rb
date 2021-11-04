# frozen_string_literal: true

#
# Abstract class for work-based controllers
#
class WorksController < ApplicationController
  include Hyrax::WorksControllerBehavior
  include Hyrax::BreadcrumbsForWorks

  #
  # Build a campus-specific form, if it exists
  #
  def build_form
    campus = current_user.campus
    @form = WorkFormService.build(campus, curation_concern, current_ability, self)
  end
end
