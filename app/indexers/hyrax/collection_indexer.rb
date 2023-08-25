#
# OVERRIDE class from Hyrax v3.6.0
# Customization: store title as sortable field and store collection as facetable
#
module Hyrax
  class CollectionIndexer < Hydra::PCDM::CollectionIndexer
    include Hyrax::IndexesThumbnails

    STORED_LONG = ActiveFedora::Indexing::Descriptor.new(:long, :stored)

    self.thumbnail_path_service = Hyrax::CollectionThumbnailPathService

    # @yield [Hash] calls the yielded block with the solr document
    # @return [Hash] the solr document WITH all changes
    def generate_solr_document
      super.tap do |solr_doc|
        # is there a reason we use
        # Solrizer.set_field(solr_doc, 'generic_type', 'Collection', :facetable)
        # solr_doc[Solrizer.solr_name(:bytes, STORED_LONG)] = object.bytes
        # instead of
        # solr_doc['generic_type_sim'] = ["Collection"]
=begin
        # Makes Collections show under the "Collections" tab
        Solrizer.set_field(solr_doc, 'generic_type', 'Collection', :facetable)
        # Index the size of the collection in bytes
        solr_doc[Solrizer.solr_name(:bytes, STORED_LONG)] = object.bytes
        solr_doc['visibility_ssi'] = object.visibility
=end
        # Makes Collections show under the "Collections" tab
        solr_doc['generic_type_sim'] = ["Collection"]
        solr_doc['visibility_ssi'] = object.visibility

        ### CUSTOMIZATION ###
        # index title in a sortable field
        solr_doc['title_ssi'] = object.title.first
        ### END #############

        object.in_collections.each do |col|
          (solr_doc['member_of_collection_ids_ssim'] ||= []) << col.id
          (solr_doc['member_of_collections_ssim'] ||= []) << col.to_s
        end
      end
    end
  end
end

