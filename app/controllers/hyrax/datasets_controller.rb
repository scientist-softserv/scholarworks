
module Hyrax
  class DatasetsController < ApplicationController
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Csu::WorksControllerBehavior

    self.curation_concern_type = ::Dataset
    self.show_presenter = Hyrax::DatasetPresenter
  end
end
