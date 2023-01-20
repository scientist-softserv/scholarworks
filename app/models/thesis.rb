# frozen_string_literal: true

#
# Thesis
#
class Thesis < ActiveFedora::Base
  include CsuFields
  include ScholarworksFields
  include FormattingFields
  include Hyrax::WorkBehavior
  include Hydra::AccessControls::CampusVisibility
  include ThesisFields

  self.indexer = ThesisIndexer
  validates :title, presence: { message: 'Your work must have a title.' }

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include Hyrax::BasicMetadata
  include CsuBehavior
  include FormattingBehavior
  include ScholarworksBehavior
  include ThesisBehavior
end
