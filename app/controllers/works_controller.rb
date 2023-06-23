# frozen_string_literal: true
#
# Based class for work-based controllers
#
class WorksController < ApplicationController
  include Hyrax::WorksControllerBehavior
  include Hyrax::BreadcrumbsForWorks
  include Scholarworks::WorkViewBehavior

  #
  # Build a campus-specific form, if it exists
  #
  def build_form
    @form = WorkFormService.build(current_user, curation_concern, current_ability, self)
  end
end
