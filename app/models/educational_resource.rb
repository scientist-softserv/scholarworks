# frozen_string_literal: true

#
# Open Educational Resource
#
class EducationalResource < ActiveFedora::Base
  include CsuFields
  include ScholarworksFields
  include FormattingFields
  include Hyrax::WorkBehavior
  include Hydra::AccessControls::CampusVisibility

  self.indexer = EducationalResourceIndexer
  validates :title, presence: { message: 'Your work must have a title.' }
  # restrict which works can be added as a child.
  # self.valid_child_concerns = []

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include Hyrax::BasicMetadata
  include CsuBehavior
  include FormattingBehavior
  include ScholarworksBehavior

  #
  # Before saving this work
  #
  def on_save
    set_year
    set_college
  end
end
