# frozen_string_literal: true
#
# Inclue Blacklight::Solr::Document and include all scholarworks specific things.
#
class SolrDocument
  include Blacklight::Solr::Document
  include BlacklightOaiProvider::SolrDocument
  include Blacklight::Gallery::OpenseadragonSolrDocument
  include Hyrax::SolrDocumentBehavior
  include ::Hydra::AccessControls::CampusVisibility

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below
  # See Blacklight::Document::SemanticFields#field_semantics and
  #     Blacklight::Document::SemanticFields#to_semantic_values
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.
  use_extension(Hydra::ContentNegotiation)

  # defer field definition to field service
  def method_missing(m, *args, &block)
    return self[Solrizer.solr_name(m.to_s)] if FieldService.all.include?(m)

    Rails.logger.warn 'Missing field: ' + m.inspect
    super
  end

  def respond_to_missing?(method_name, include_private = false)
    FieldService.all.include?(method_name) || super
  end

  #
  # Title with any HTML formatting
  #
  # For title with no formatting use `title`
  #
  # @return [Array]
  #
  def title_formatted
    title = self['title_formatted_ssm']
    return title unless title.blank?

    self[Solrizer.solr_name('title')]
  end

  #
  # Description with any HTML formatting
  #
  # For description with no formatting use `description`
  #
  # @return [Array]
  #
  def description_formatted
    description = self['description_formatted_ssm']
    return description unless description.blank?

    self[Solrizer.solr_name('description')]
  end

  def description_short(length = 200)
    desc = self[Solrizer.solr_name('description')]
    return '' if desc.blank?
    return '' unless desc.count.positive?

    desc.first.truncate(length)
  end

  # blacklight_oai_provider mapping
  field_semantics.merge! FieldService.oai_mapping
end
