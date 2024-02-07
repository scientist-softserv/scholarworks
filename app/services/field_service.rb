# frozen_string_literal: true

#
# Field Service
#
# This service is used in the CatalogController, CsuForm, SolrDocument &
# CsuPresenter to reduce the number of redundant places fields are defined.
#
# To add a new field, add it to the appropriate model and then here:
# (a) add it to `basic`, `scholarworks` or `archives` method, as appropriate
# (b) add it to `single_fields`, if it is single-valued
# (c) add it to oai-pmh field mapping
#
class FieldService
  #
  # Fields shared by all models
  #
  # @return [Array<Symbol>]
  #
  def self.basic
    %i[alternative_title
       campus
       contributor
       creator
       date_issued
       date_issued_year
       description
       description_note
       embargo_terms
       extent
       external_id
       external_modified_date
       external_system
       external_url
       file_type
       handle
       identifier
       internal_note
       keyword
       language
       license
       provenance
       related_url
       resource_type
       rights_note
       source
       subject
       title]
  end

  #
  # ScholarWorks fields
  #
  # @return [Array<Symbol>]
  #
  def self.scholarworks
    %i[advisor
       award_number
       college
       committee_member
       data_note
       data_type
       date_last_modified
       date_range
       degree_level
       degree_name
       degree_program
       department
       discipline
       doi
       edition
       editor
       granting_institution
       isbn
       issn
       issue
       meeting_name
       methods_of_collection
       oclcno
       pages
       place
       publication_title
       publisher
       series
       sponsor
       statement_of_responsibility
       volume]
  end

  #
  # Fields to remove after new schema in place
  #
  # @return [Array<Symbol>]
  #
  def self.deprecated
    %i[abstract
       bibliographic_citation
       date_accessioned
       date_available
       date_copyright
       date_submitted
       identifier_uri
       investigator
       publication_status
       time_period]
  end

  #
  # Digital Archives fields
  #
  # @return [Array<Symbol>]
  #
  def self.archives
    %i[digital_project
       file_format
       format
       funding_code
       geographical_area
       has_finding_aid
       institution
       interviewee
       interviewer
       is_part_of
       repository
       rights_holder
       work_type]
  end

  #
  # All public fields
  #
  # @return [Array<Symbol>]
  #
  def self.fields
    basic + scholarworks + archives
  end

  #
  # All ScholarWorks fields
  #
  # @return [Array<Symbol>]
  #
  def self.scholarworks_fields
    basic + scholarworks
  end

  #
  # All Digital Archives fields
  #
  # @return [Array<Symbol>]
  #
  def self.archives_fields
    basic + archives
  end

  #
  # All public fields, including deprecated ones
  #
  # @return [Array<Symbol>]
  #
  def self.all
    basic + scholarworks + deprecated + archives + %i[creator_name]
  end

  #
  # Fedora internal-use fields
  #
  # @return [Array<String>]
  #
  def self.fedora
    %w[arkivo_checksum
       access_control_id
       embargo_id
       head
       import_url
       label
       lease_id
       owner
       relative_path
       rendering_ids
       representative_id
       state
       tail
       thumbnail_id]
  end

  #
  # All internal Fields
  #
  # @return [Array<String>]
  #
  def self.internal_fields
    fedora + %w[date_issued_year
                external_modified_date
                external_system
                external_url]
  end

  #
  # Fields that have single values
  #
  # @return [Array<String>]
  #
  def self.single_fields
    # model is a utility field in csv import
    # file_size is from FileSet
    %w[admin_set_id
       date_accessioned
       degree_level
       depositor
       edition
       embargo_release_date
       external_id
       external_system
       external_modified_date
       external_url
       file_size
       id
       issue
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
  # @return [Array<String>]
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
  # @return [Array<String>]
  #
  def self.person_fields
    %w[advisor
       contributor
       committee_member
       creator
       editor]
  end

  #
  # Fields that contain date values
  #
  # @return [Array<String>]
  #
  def self.date_fields
    %w[date_issued
       date_last_modified
       date_modified
       date_uploaded
       external_modified_date]
  end

  #
  # Identifier fields that look like numbers but should not be treated as such
  #
  # @return [Array<String>]
  #
  def self.identifier_fields
    %w[admin_set_id
       id
       isbn
       issn
       oclc]
  end

  #
  # Fields to show
  #
  # @return [Array<String>]
  #
  def self.show_fields
    fields.map &:to_s
  end

  #
  # Fields to search
  #
  # @return  [Array<String>]
  #
  def self.search_fields
    s_fields = []
    text_fields = fields.map &:to_s

    # handle person fields later
    text_fields = text_fields - person_fields
    text_fields.each do |field|
      s_fields << "#{field}_tesim"
    end

    # for person fields, only use name instead of the whole field
    person_fields.each do |field|
      s_fields << "#{field}_name_tesim"
    end

    # extra fields
    s_fields + %w[all_text_timv handle_sim id']
  end
  #
  # OAI-PMH mapping of internal fields to dc fields
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
      creator: 'creator_tesim',
      date: %w[date_issued_tesim
               date_copyright_tesim],
      description: %w[description_tesim
                      description_note_tesim
                      publication_status_tesim
                      bibliographic_citation_tesim
                      identifier_tesim
                      doi_tesim
                      isbn_tesim
                      issn_tesim],
      format: 'format',
      identifier: 'handle_tesim',
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
  # @param node [Nokogiri::XML]  record node from Nokogiri XML (don't just pass in the whole document!)
  #
  # @return [Hash]
  #
  def self.xml_to_params(node)
    params = {}
    node.xpath('field').each do |field|
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
