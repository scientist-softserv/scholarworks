# frozen_string_literal: true
#
# Theses controller
#
module Hyrax
  class ThesesController < WorksController
    self.curation_concern_type = ::Thesis
    self.show_presenter = Hyrax::ThesisPresenter
  end
end
