# frozen_string_literal: true
#
# Educational resources controller
#
module Hyrax
  class EducationalResourcesController < WorksController
    self.curation_concern_type = ::EducationalResource
    self.show_presenter = Hyrax::EducationalResourcePresenter
  end
end
