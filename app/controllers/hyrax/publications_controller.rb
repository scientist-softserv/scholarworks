
module Hyrax
  class PublicationsController < ApplicationController
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Csu::WorksControllerBehavior

    self.curation_concern_type = ::Publication
    self.show_presenter = Hyrax::PublicationPresenter
  end
end
