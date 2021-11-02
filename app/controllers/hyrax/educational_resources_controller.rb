
module Hyrax
  class EducationalResourcesController < ApplicationController
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Csu::WorksControllerBehavior

    self.curation_concern_type = ::EducationalResource
    self.show_presenter = Hyrax::EducationalResourcePresenter
  end
end
