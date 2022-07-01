require 'calstate/metadata'

module WillowSword
  class CrosswalkFromDspace
    attr_reader :dc, :metadata, :model, :mapped_metadata, :files_metadata,
                :terms, :translated_terms, :singular

    def initialize(src_file, headers)
      @src_file = src_file
      @headers = headers
      @dc = nil
      @model = nil
      @metadata = {}
      @mapped_metadata = {}
      @files_metadata = []
    end

    def terms
      %w[abstract accessRights accrualMethod accrualPeriodicity
         accrualPolicy alternative audience available bibliographicCitation
         conformsTo contributor coverage created creator date dateAccepted
         dateCopyrighted dateSubmitted description educationLevel extent
         format hasFormat hasPart hasVersion identifier instructionalMethod
         isFormatOf isPartOf isReferencedBy isReplacedBy isRequiredBy issued
         isVersionOf language license mediator medium modified provenance
         publisher references relation replaces requires rights rightsHolder
         source spatial subject tableOfContents temporal title type valid]
    end

    def translated_terms
      {
        'created' => 'date_created',
        'rights' => 'rights_note',
        'relation' => 'related_url',
        'type' => 'resource_type'
      }
    end

    def map_xml
      parse_dc
      @mapped_metadata = @metadata
      assign_model if @metadata.any?
    end

    def parse_dc
      return @metadata unless @src_file.present?
      return @metadata unless File.exist? @src_file

      # transform the incoming xml data into a standard xml format
      sword_doc = Nokogiri::XML(File.read(@src_file))
      xslt_file = File.join(Rails.root, 'config', 'mappings', 'sword.xslt')
      xslt = Nokogiri::XSLT(File.read(xslt_file))
      doc = xslt.transform(sword_doc)

      # convert to params
      @metadata = FieldService.xml_to_params(doc.root)
    end

    def assign_model
      unless @metadata.fetch('resource_type', nil).blank?
        resource_type = @metadata['resource_type'].first
        if ::CalState::Metadata.model_type_map.key?(resource_type)
          model = ::CalState::Metadata.model_type_map[resource_type].to_s
          Rails.logger.warn "Found '#{model}' for '#{resource_type}'."
          return model
        end
      end

      'Thesis'
    end
  end
end
