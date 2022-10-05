# frozen_string_literal: true

require 'builder'

##
# Monkey-patched this file from the Blacklight OAI-PMH Provider gem to:
# (a) add 'campus' as an allowed field (see dublin_core_field_names)
# (b) author name only from composite author fields
#

# This module provide Dublin Core export based on the document's semantic values
module Blacklight::Document::DublinCore
  def self.extended(document)
    # Register our exportable formats
    Blacklight::Document::DublinCore.register_export_formats(document)
  end

  def self.register_export_formats(document)
    document.will_export_as(:xml)
    document.will_export_as(:dc_xml, 'text/xml')
    document.will_export_as(:oai_dc_xml, 'text/xml')
  end

  def dublin_core_field_names
    # customization: add campus
    FieldService.oai_fields
  end

  # dublin core elements are mapped against the #dublin_core_field_names whitelist.
  def export_as_oai_dc_xml
    xml = Builder::XmlMarkup.new
    xml.tag!('oai_dc:dc',
             'xmlns:oai_dc' => 'http://www.openarchives.org/OAI/2.0/oai_dc/',
             'xmlns:dc' => 'http://purl.org/dc/elements/1.1/',
             'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
             'xsi:schemaLocation' => %(http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd)) do
      to_semantic_values.select { |field, values| dublin_core_field_name? field  }.each do |field, values|
        Array.wrap(values).each do |v|


          # customization: only name from composite person
          if %i[creator contributor].include?(field)
            person = CompositeElement.new.from_hyrax(v)
            v = person.get(CompositeElement::NAME)
          end

          # customization: map internal types to oai-pmh types
          # keep internal type as dc:genre
          if field == :type

            FieldService.oai_types.each do |type, dc_type|
              if type == v
                xml.tag! 'dc:genre', v
                v = dc_type
              end
            end
          end


          v = ActionView::Base.full_sanitizer.sanitize(v)
          xml.tag! "dc:#{field}", v
        end
      end
    end
    xml.target!
  end

  alias_method :export_as_xml, :export_as_oai_dc_xml
  alias_method :export_as_dc_xml, :export_as_oai_dc_xml

  private

  def dublin_core_field_name?(field)
    dublin_core_field_names.include? field.to_sym
  end
end
