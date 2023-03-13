module Hyrax 
  module Renderers
    class ArchivePersonLinkAttributeRenderer < FacetedAttributeRenderer

      def render
        markup = ''
        return markup if values.blank? && !options[:include_empty]

        markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
        attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")
        values.each do |value|
          person = CompositeElement.new([CompositeElement::NAME, CompositeElement::ROLE, CompositeElement::IDENTIFIER]).from_hyrax(value)
          markup << "<li#{html_attributes(attributes)}>" +
              attribute_value_to_html(field.to_s, person) +
              '</li>'
        end
        markup << %(</ul></td></tr>)
        markup.html_safe
      end

      # Draw the dl row for the attribute
      def render_dl_row
        markup = ''
        return markup if values.blank? && !options[:include_empty]

        markup << %(<dt>#{label}</dt>\n<dd><ul class='tabular'>)
        attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")
        values.each do |value|
          person = CompositeElement.new([CompositeElement::NAME, CompositeElement::ROLE, CompositeElement::IDENTIFIER]).from_hyrax(value)
          markup << "<li#{html_attributes(attributes)}>" +
              attribute_value_to_html(field.to_s, person) +
              '</li>'
        end
        markup << %(</ul></dd>)
        markup.html_safe
      end

      def attribute_value_to_html(person_type, composite_element)
        return_val = '<div class="csu-person">' \
          '<div class="csu-name"">' \
          "<span #{html_attributes(microdata_value_attributes(field))}>#{li_value(composite_element.get(CompositeElement::NAME))}</span>" \
          '</div>'
        unless composite_element.get(CompositeElement::ROLE).nil?
          return_val += "<div class='csu-role'>#{composite_element.get(CompositeElement::ROLE)}</div>"
        end
        unless composite_element.get(CompositeElement::IDENTIFIER).nil?
          return_val += "<div class='csu-identifier'>#{composite_element.get(CompositeElement::IDENTIFIER)}</div>"
        end

        return_val
      end
    end
  end
end
