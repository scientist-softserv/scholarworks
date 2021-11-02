
module Hyrax
  class ThesesController < ApplicationController
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Csu::WorksControllerBehavior

    self.curation_concern_type = ::Thesis
    self.show_presenter = Hyrax::ThesisPresenter
  end
end
