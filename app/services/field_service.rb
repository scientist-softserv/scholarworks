# frozen_string_literal: true

#
# ScholarWorks fields
#
# This service is used in the CatalogController, CsuForm, SolrDocument &
# CsuPresenter to reduce the number of redundant places fields are defined.
#
# To add a new field, add it to the appropriate model and then here:
# (a) add it to `fields` method
# (b) add it to `single_fields`, if it is single-valued
# (c) add it to oai-pmh field mapping
#
class FieldService
  #
  # All fields
  #
  # @return [Array] symbols
  #
  def self.fields
    %i[advisor
       alternative_title
       award_number
       campus
       college
       committee_member
       contributor
       creator
       creator_name
       data_note
       data_type
       date_issued
       date_issued_year
       date_last_modified
       date_range
       degree_level
       degree_name
       degree_program
       department
       description
       description_note
       discipline
       doi
       edition
       editor
       extent
       external_id
       granting_institution
       handle
       identifier
       internal_note
       is_part_of
       isbn
       issn
       issue
       keyword
       language
       license
       meeting_name
       methods_of_collection
       oclcno
       pages
       place
       provenance
       publication_title
       publisher
       related_url
       resource_type
       rights_note
       series
       source
       sponsor
       statement_of_responsibility
       subject
       title
       volume]
  end

  #
  # Fields to remove after new schema in place
  #
  # @return [Array] symbols
  #
  def self.deprecated
    %i[abstract
       bibliographic_citation
       date_accessioned
       date_available
       date_copyright
       date_submitted
       embargo_terms
       geographical_area
       journal_title
       identifier_uri
       investigator
       publication_status
       rights_holder
       rights_statement
       rights_uri
       time_period]
  end

  #
  # All fields, including deprecated ones
  #
  # @return [Array] symbols
  #
  def self.all
    fields + deprecated
  end

  #
  # Fields that have single values
  #
  # @return [Array] string
  #
  def self.single_fields
    # model is a utility field in csv import
    %w[date_accessioned
       degree_level
       edition
       embargo_release_date
       external_id
       external_system
       external_modified_date
       id
       issue
       journal_title
       meeting_name
       model
       pages
       place
       visibility
       visibility_after_embargo
       visibility_during_embargo
       volume]
  end

  #
  # Fields for visibility, so not in work attributes
  #
  # @return [Array] string
  #
  def self.visibility_fields
    %w[embargo_release_date
       visibility
       visibility_during_embargo
       visibility_after_embargo]
  end

  #
  # Fields with person objects
  #
  # @return [Array] string
  #
  def self.person_fields
    %w[advisor
       contributor
       committee_member
       creator
       editor]
  end

  #
  # Fields to search
  #
  # @return  [Array] string
  #
  def self.search_fields
    fields.map &:to_s
  end

  #
  # Facet fields
  #
  # @return [Hash]  as field => no. to display
  #
  def self.facets
    {
      resource_type: { limit: 5 },
      campus: { limit: 10 },
      department: { limit: 5 },
      degree_level: { limit: 5 },
      date_issued_year: { range: true, include_in_advanced_search: false, sort: 'index'}
    }
  end

  #
  # Advanced search fields
  #
  # @return [Array] string
  #
  def self.advanced_search
    %w[title
       creator
       publisher
       keyword
       subject
       discipline
       handle]
  end

  #
  # OAI-PMH mapping of scholarworks fields to dc fields
  #
  # @return [Hash]
  #
  def self.oai_mapping
    {
      contributor: %w[contributor_tesim
                      advisor_tesim
                      committee_member_tesim
                      editor_tesim],
      coverage: %w[coverage_tesim
                   time_period_tesim
                   geographical_area_tesim],
      creator: %w[creator_tesim
                  author_tesim],
      date: %w[date_issued_tesim
               date_copyright_tesim],
      description: %w[description_tesim
                      abstract_tesim
                      publication_status_tesim
                      bibliographic_citation_tesim],
      format: 'format',
      identifier: %w[handle_tesim
                     identifier_tesim
                     doi_tesim
                     isbn_tesim
                     issn_tesim],
      language: 'language_tesim',
      publisher: %w[publisher_tesim
                    sponsor_tesim
                    college_tesim
                    department_tesim
                    granting_institution_tesim],
      relation: 'relation_tesim',
      rights: %w[rights_tesim
                 rights_statement_tesim
                 rights_note_tesim
                 rights_holder_tesim
                 rights_uri_tesim
                 license_tesim],
      source: 'source_tesim',
      subject: %w[subject_tesim
                  keyword_tesim],
      title: %w[title_tesim
                alternative_title_tesim],
      type: %w[resource_type_tesim],
      campus: %w[campus_tesim]
    }
  end

  #
  # DC fields to include in OAI-PMH
  #
  # @return [Array] symbols
  #
  def self.oai_fields
    oai_mapping.keys
  end

  #
  # OAI-PMH Map internal types
  #
  # The values we are mapping to are from Primo (CDI)
  #
  # @return [Hash]
  #
  def self.oai_types
    {
      'Article' => 'Article',
      'Assessment Tool' => 'Text Resource',
      'Book' => 'Book',
      'Book Chapter' => 'Book Chapter',
      'Conference Proceeding' => 'Conference proceeding',
      'Course Material' => 'Text Resource',
      'Dataset' => 'Dataset',
      'Dissertation' => 'Thesis and Dissertation',
      'Doctoral Project' => 'Thesis and Dissertation',
      'Graduate Project' => 'Thesis and Dissertation',
      'Journal Issue' => 'Journal',
      "Master's Thesis" => 'Thesis and Dissertation',
      'Open Textbook' => 'Book',
      'Performance' => 'Text Resource',
      'Presentation' => 'Text Resource',
      'Report' => 'Report',
      'Undergraduate Project' => 'Text Resource'
    }
  end

  #
  # Convert simple fields XML to hash of params
  #
  # @param doc [Nokogiri::XML]  node or document with simple xml record
  #
  # @return [Hash]
  #
  def self.xml_to_params(doc)
    params = {}
    doc.xpath('field').each do |field|
      next unless field.text.present?

      field_name = field.attr('name')
      field_value = field.text.squish
      is_singular = single_fields.include?(field_name.to_s)

      if params.key?(field_name) && !is_singular
        params[field_name] << field_value
      else
        params[field_name] = if is_singular
                               field_value
                             else
                               [field_value]
                             end
      end
    end

    params
  end
end
