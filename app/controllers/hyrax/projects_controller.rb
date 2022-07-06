# frozen_string_literal: true

#
# Projects controller
#
module Hyrax
  class ProjectsController < WorksController
    self.curation_concern_type = ::Project
    self.show_presenter = Hyrax::ProjectPresenter
  end
end
