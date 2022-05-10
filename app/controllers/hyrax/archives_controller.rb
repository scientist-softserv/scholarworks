# frozen_string_literal: true

#
# Archives controller
#
module Hyrax
  class ArchivesController < WorksController
    self.curation_concern_type = ::Archive
    self.show_presenter = Hyrax::ArchivePresenter
  end
end