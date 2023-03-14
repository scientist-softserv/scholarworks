module Hyrax 
  module Renderers
    module PersonAttribute
      extend ActiveSupport::Concern

      def render
        Rails.logger.error "PersonAttribute:render"
        markup = ''

        return markup if values.blank? && !options[:include_empty]

        markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
        attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")
        values.each do |value|
          person = CompositeElement.new.from_hyrax(value)
          markup << "<li#{html_attributes(attributes)}>" +
                    attribute_value_to_html(field.to_s, person) +
                    '</li>'
        end
        markup << %(</ul></td></tr>)
        markup.html_safe
      end

      # Draw the dl row for the attribute
      def render_dl_row
        Rails.logger.error "PersonAttribute:render_dl_row"
        markup = ''
        return markup if values.blank? && !options[:include_empty]

        markup << %(<dt>#{label}</dt>\n<dd><ul class='tabular'>)
        attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")
        values.each do |value|
          person = CompositeElement.new.from_hyrax(value)
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
          "<span #{html_attributes(microdata_value_attributes(field))}>#{li_value(composite_element.get(CompositeElement::NAME))}</span>"
        unless composite_element.get(CompositeElement::ORCID).nil?
          return_val += '<span class="csu-orcid">' \
            "<a target='_blank' href='https://orcid.org/#{composite_element.get(CompositeElement::ORCID)}'>" \
            "<img alt='ORCID profile for #{person_type} #{composite_element.get(CompositeElement::NAME)}' class='profile' src='/assets/orcid-cb273c1ff10d304ce1b6108a172bfd1660561e7fd8133b083cd66ee0f4a0a944.png' />" \
            '</a>' \
            '</span>'
        end
        return_val += '</div>'
        unless composite_element.get(CompositeElement::INSTITUTION).nil?
          return_val += "<div class='csu-institution'>#{composite_element.get(CompositeElement::INSTITUTION)}</div>"
        end
        return_val += '</div>'

        return_val
      end
    end
  end
end
