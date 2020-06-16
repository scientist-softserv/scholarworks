# Generated by hyrax:models:install
class FileSet < ActiveFedora::Base
  property :glacier_location, predicate: ::RDF::URI.intern('https://cal-state.edu/file_set/glacier_location'), multiple: true do |index|
    index.as :stored_searchable
  end

  include ::Hyrax::FileSetBehavior

  def glacier_upload
    GlacierUploadService.upload(self)
  end
end

