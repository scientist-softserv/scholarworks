# frozen_string_literal: true

#
# Publication
#
class Publication < ActiveFedora::Base
  include CsuFields
  include FormattingFields
  include Hyrax::WorkBehavior
  include Hydra::AccessControls::CampusVisibility

  self.indexer = PublicationIndexer
  validates :title, presence: { message: 'Your work must have a title.' }
  # restrict which works can be added as a child.
  # self.valid_child_concerns = []

  property :edition, predicate: ::RDF::Vocab::BIBO.edition, multiple: false

  property :editor, predicate: ::RDF::Vocab::MARCRelators.edt do |index|
    index.as :stored_searchable
  end

  property :issue, predicate: ::RDF::Vocab::BIBO.issue, multiple: false

  # @depricated
  property :journal_title, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasJournal'), multiple: false do |index|
    index.as :stored_searchable, :facetable
  end

  property :pages, predicate: ::RDF::Vocab::BIBO.pages, multiple: false

  property :series, predicate: ::RDF::URI.new('http://purl.org/net/nknouf/ns/bibtex#hasSeries') do |index|
    index.as :stored_searchable
  end

  property :volume, predicate: ::RDF::Vocab::BIBO.volume, multiple: false

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include Hyrax::BasicMetadata
  include CsuBehavior
  include FormattingBehavior

  def editor
    OrderedStringHelper.deserialize(super)
  end

  def editor=(values)
    super sanitize_n_serialize(values)
  end
end
