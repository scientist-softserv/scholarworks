module WillowSword
  class CrosswalkFromDspace
    attr_reader :dc, :metadata, :model, :mapped_metadata, :files_metadata, :terms, :translated_terms, :singular

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
      %w(abstract accessRights accrualMethod accrualPeriodicity
        accrualPolicy alternative audience available bibliographicCitation
        conformsTo contributor coverage created creator date dateAccepted
        dateCopyrighted dateSubmitted description educationLevel extent
        format hasFormat hasPart hasVersion identifier instructionalMethod
        isFormatOf isPartOf isReferencedBy isReplacedBy isRequiredBy issued
        isVersionOf language license mediator medium modified provenance
        publisher references relation replaces requires rights rightsHolder
        source spatial subject tableOfContents temporal title type valid)
    end

    def translated_terms
      {
      'created' =>'date_created',
      'rights' => 'rights_statement',
      'relation' => 'related_url',
      'type' => 'resource_type'
      }
    end

    def singular
      %w(rights degree_level)
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
      # that can then be simply imported into a new record
      sword_doc = Nokogiri::XML(File.read(@src_file))
      xslt_file = File.join(Rails.root, 'config', 'sword', 'sword.xslt')
      xslt = Nokogiri::XSLT(File.read(xslt_file))
      doc = xslt.transform(sword_doc)

      @metadata[:visibility] = 'open'

      doc.xpath('//field').each do |field|
        next unless field.text.present?

        field_name = field.attr('name').to_sym
        is_singular = singular.include?(field_name.to_s)

        if @metadata.key?(field_name) && !is_singular
          @metadata[field_name] << field.text
        else
          @metadata[field_name] = if is_singular
                                    field.text
                                  else
                                    [field.text]
                                  end
        end
      end
    end

    def assign_model
      # unless @metadata.fetch(:resource_type, nil).blank?
      #   @model = Array(@metadata[:resource_type]).map {
      #     |t| t.underscore.gsub('_', ' ').gsub('-', ' ').downcase
      #   }.first
      # end
      'Thesis'
    end

  end
end
