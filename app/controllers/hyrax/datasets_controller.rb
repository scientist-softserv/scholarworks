# frozen_string_literal: true

#
# Dataset controller
#
module Hyrax
  class DatasetsController < WorksController
    self.curation_concern_type = ::Dataset
    self.show_presenter = Hyrax::DatasetPresenter
  end
end
