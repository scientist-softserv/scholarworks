
# All models inherit from Hyrax::BasicMetadata, which includes:
#   creator           RDF::Vocab::DC11.creator
#   keyword	          RDF::Vocab::DC11.relation
#   rights_statement  RDF::Vocab::EDM.rights
#   contributor	      RDF::Vocab::DC11.contributor
#   description	      RDF::Vocab::DC11.description
#   license	          RDF::Vocab::DC.rights
#   publisher	        RDF::Vocab::DC11.publisher
#   date_created	    RDF::Vocab::DC.created
#   subject	          RDF::Vocab::DC11.subject
#   language	        RDF::Vocab::DC11.language
#   identifier	      RDF::Vocab::DC.identifier
#   based_near	      RDF::Vocab::FOAF.based_near
#   related_url	      RDF::RDFS.seeAlso
#   source	          RDF::Vocab::DC.source
#   resource_type	    RDF::Vocab::DC.type

module CsuMetadata
  extend ActiveSupport::Concern

  included do

    property :abstract, predicate: ::RDF::Vocab::DC.abstract do |index|
      index.as :stored_searchable
    end

    property :alternative_title, predicate: ::RDF::Vocab::DC.alternative do |index|
      index.as :stored_searchable
    end

    property :campus, predicate: ::RDF::Vocab::DC.publisher do |index|
      index.as :stored_searchable, :facetable
    end

    property :college, predicate: ::RDF::Vocab::SCHEMA.CollegeOrUniversity do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_accessioned, predicate: ::RDF::Vocab::DC.date, multiple: false do |index|
      index.as :stored_searchable
    end

    property :date_available, predicate: ::RDF::Vocab::DC.available do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_copyright, predicate: ::RDF::Vocab::DC.dateCopyrighted do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_issued, predicate: ::RDF::Vocab::DC.issued do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_issued_year, predicate: ::RDF::Vocab::SCHEMA.datePublished, multiple: false do |index|
      index.as :stored_searchable, :facetable
    end

    property :date_submitted, predicate: ::RDF::Vocab::SCHEMA.Date do |index|
      index.as :stored_searchable, :facetable
    end

    property :department, predicate: ::RDF::Vocab::SCHEMA.department do |index|
      index.as :stored_searchable, :facetable
    end

    property :description_note, predicate: ::RDF::Vocab::SCHEMA.description do |index|
      index.as :stored_searchable
    end

    property :doi, predicate: ::RDF::Vocab::SCHEMA.identifier do |index|
      index.as :stored_searchable
    end

    property :embargo_terms, predicate: ::RDF::Vocab::DC.description, multiple: false do |index|
      index.as :stored_searchable
    end

    property :extent, predicate: ::RDF::Vocab::DC.extent do |index|
      index.as :stored_searchable
    end

    property :geographical_area, predicate: ::RDF::Vocab::DC.spatial do |index|
      index.as :stored_searchable
    end

    property :handle, predicate: ::RDF::Vocab::PREMIS.ContentLocation do |index|
      index.as :stored_searchable
    end

    property :identifier_uri, predicate: ::RDF::URI.new('http://id.loc.gov/vocabulary/identifiers/uri') do |index|
      index.as :stored_searchable
    end

    property :is_part_of, predicate: ::RDF::Vocab::DC.relation do |index|
      index.as :stored_searchable
    end

    property :isbn, predicate: ::RDF::Vocab::SCHEMA.isbn do |index|
      index.as :stored_searchable
    end

    property :issn, predicate: ::RDF::Vocab::SCHEMA.issn do |index|
      index.as :stored_searchable
    end

    property :license, predicate: ::RDF::Vocab::DC.license do |index|
      index.as :stored_searchable, :facetable
    end

    property :oclcno, predicate: ::RDF::Vocab::BIBO.oclcnum do |index|
      index.as :stored_searchable
    end

    property :provenance, predicate: ::RDF::Vocab::DC.provenance do |index|
      index.as :stored_searchable
    end

    property :rights_holder, predicate: ::RDF::Vocab::DC.rightsHolder do |index|
      index.as :stored_searchable
    end

    property :rights_note, predicate: ::RDF::Vocab::EBUCore.rightsExpression do |index|
      index.as :stored_searchable
    end

    property :rights_uri, predicate: ::RDF::URI.new('http://purl.org/dc/elements/1.1/rights') do |index|
      index.as :stored_searchable
    end

    property :sponsor, predicate: ::RDF::Vocab::MARCRelators.spn do |index|
      index.as :stored_searchable
    end

    property :statement_of_responsibility, predicate: ::RDF::Vocab::MARCRelators.rpy do |index|
      index.as :stored_searchable
    end

    property :time_period, predicate: ::RDF::Vocab::DC.temporal do |index|
      index.as :stored_searchable, :facetable
    end

    property :discipline, predicate: ::RDF::Vocab::DC.subject, multiple: true do |index|
      index.as :stored_searchable, :facetable
    end

    def discipline= values
      saved_values = []
      values.each do |v|
        next if DisciplineService::DISCIPLINES[v].nil?

        saved_values << v
      end
      super saved_values.uniq
    end

  end

  def handle_suffix
    return nil if handle.blank?

    handle.map { |url| url.split('/')[-1] }
  end

  #
  # Assign campus name based on admin set
  #
  # @param admin_set_title [String]  name of admin set
  #
  def assign_campus(admin_set_title)
    campus = Hyrax::CampusService.get_campus_from_admin_set(admin_set_title)
    self.campus = [campus]
  end

  #
  # Save this work
  #
  def save(*options)
    raise 'No admin set defined for this item.' if admin_set&.title&.first.nil?

    assign_campus(admin_set.title.first.to_s)
    set_year

    Rails.logger.warn options
    super(*options)
  end

  def sanitize_n_serialize(values)
    full_sanitizer = Rails::Html::FullSanitizer.new
    sanitized_values = Array.new(values.size, '')
    values.each_with_index do |v, i|
      sanitized_values[i] = full_sanitizer.sanitize(v) unless v == '|||'
    end
    OrderedStringHelper.serialize(sanitized_values)
  end


  protected

  #
  # Set year for work
  #
  def set_year
    year = if self.date_issued.count.zero?
             self.date_uploaded
           else
             self.date_issued.first
           end
    self.date_issued_year = extract_year(year)
  end

  #
  # Extract four-digit year from date issued, for facet
  #
  # @param date_issued [String]
  #
  # @return [String]
  #
  def extract_year(date_issued)
    # no date, no mas
    return nil if date_issued.nil?

    # make sure this is a string
    date_issued = date_issued.to_s

    # found four-digit year, cool
    match = /1[89][0-9]{2}|2[01][0-9]{2}/.match(date_issued)
    return match[0] unless match.nil?

    # date in another format, use chronic
    date = Chronic.parse(date_issued, context: 'past')
    now = Date.today
    format = '%Y-%m-%d'

    # chronic didn't find a date
    return nil if date.nil?

    # chronic returned current date, so a miss
    return nil if date.strftime(format) == now.strftime(format)

    # year way out of range, likely a typo
    year = date.year
    return nil if year < 1900 || year > (Date.today.year + 5)

    year.to_s # actual extracted year!
  end
end
