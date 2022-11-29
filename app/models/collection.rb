# frozen_string_literal: true

#
# Collection
#
class Collection < ActiveFedora::Base
  include FormattingFields
  include Hyrax::CollectionBehavior

  validates :title, presence: { message: 'Your work must have a title.' }
  before_create :on_create

  property :campus, predicate: ::RDF::Vocab::DC.publisher do |index|
    index.as :stored_searchable, :facetable
  end

  property :handle, predicate: ::RDF::Vocab::PREMIS.ContentLocation do |index|
    index.as :stored_searchable
  end

  self.indexer = Hyrax::CollectionWithBasicMetadataIndexer

  include Hyrax::BasicMetadata
  include FormattingBehavior

  def on_create
    set_campus
  end

  #
  # Set campus based on the depositor
  #
  def set_campus
    user = User.find_by_user_key(depositor)
    campus_name = user.campus_name
    self.campus = [campus_name]
  end

  def save(*options)
    self.resource_type = ['Collection']
    super(*options)
  end
end
