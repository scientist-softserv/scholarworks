#
# OVERRIDE class from hyrax v3.6.0
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
        # Makes Collections show under the "Collections" tab
        solr_doc['visibility_ssi'] = object.visibility



        ### CUSTOMIZATION:
        # index the size of the collection in bytes
        # index title in a sortable field

        solr_doc['bytes_lts'] = object.bytes
        solr_doc['title_ssi'] = object.title.first

        ### END CUSTOMIZATION



        object.in_collections.each do |col|
          (solr_doc['member_of_collection_ids_ssim'] ||= []) << col.id
          (solr_doc['member_of_collections_ssim'] ||= []) << col.to_s
        end
      end
    end
  end
end

