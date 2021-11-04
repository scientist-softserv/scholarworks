# frozen_string_literal: true

#
# Publications controller
#
module Hyrax
  class PublicationsController < WorksController
    self.curation_concern_type = ::Publication
    self.show_presenter = Hyrax::PublicationPresenter
  end
end
