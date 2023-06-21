# This stands in for an object to be created from the BatchUploadForm.
# It should never actually be persisted in the repository.
# The properties on this form should be copied to a real work type.
#
# OVERRIDE class from Hyrax v2.9.6
# Customization: Combine all multivalues of description into a single one for the front end
#
class BatchUploadItem < ActiveFedora::Base
  include Hyrax::WorkBehavior
  # This must come after the WorkBehavior because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata

  attr_accessor :payload_concern # a Class name: what is this a batch of?

  # This mocks out the behavior of Hydra::PCDM::PcdmBehavior
  def in_collection_ids
    []
  end

  def descriptions
    combined_val = ''
    description.each do |d|
      combined_val << d
    end
    combined_val
  end

  def create_or_update
    raise "This is a read only record"
  end
end
