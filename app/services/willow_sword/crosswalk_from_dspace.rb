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
      %w(rights email)
    end

    def map_xml
      parse_dc
      @mapped_metadata = @metadata
      assign_model if @metadata.any?
    end

    CONFIG = {
      title: {
        element: 'DISS_title'
      },
      email: {
        element: 'DISS_email',
        single_value: true
      },
    }

    def parse_dc
      return @metadata unless @src_file.present?
      return @metadata unless File.exist? @src_file
      f = File.open(@src_file)
      @doc = Nokogiri::XML(f)
      # doc = Nokogiri::XML(@xml_metadata)
      @doc.remove_namespaces!
      CONFIG.each do |target_attr, config_values|
        values = []
        @doc.xpath("//#{CONFIG[target_attr][:element]}").each do |element|
          values << element.text if element.text.present?
          values = values.first if values.present? && CONFIG[target_attr][:single_value]
          @metadata[target_attr] = values unless values.blank?
        end
      end
      f.close
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

