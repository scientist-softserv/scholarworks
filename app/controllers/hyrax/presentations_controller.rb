# frozen_string_literal: true
#
# Publications controller
#
module Hyrax
  class PresentationsController < WorksController
    self.curation_concern_type = ::Presentation
    self.show_presenter = Hyrax::PresentationPresenter
  end
end
