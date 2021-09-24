require 'rails_autolink/helpers'

module Hyrax
  module Renderers
    module PersonAttribute
      extend ActiveSupport::Concern

      def render
        markup = ''

        return markup if values.blank? && !options[:include_empty]

        markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
        attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")
        values.each do |value|
          person = Person.new.from_hyrax(value)
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
          person = Person.new.from_hyrax(value)
          markup << "<li#{html_attributes(attributes)}>" +
                    attribute_value_to_html(field.to_s, person) +
                    '</li>'
        end
        markup << %(</ul></dd>)
        markup.html_safe
      end

      def attribute_value_to_html(person_type, person)
        return_val = '<div class="csu-person">' \
          '<div class="csu-name"">' \
          "<span #{html_attributes(microdata_value_attributes(field))}>#{li_value(person.name)}</span>"
        unless person.orcid.nil?
          return_val += '<span class="csu-orcid">' \
            "<a target='_blank' href='https://orcid.org/#{person.orcid}'>" \
            "<img alt='ORCID profile for #{person_type} #{person.name}' class='profile' src='/assets/orcid-cb273c1ff10d304ce1b6108a172bfd1660561e7fd8133b083cd66ee0f4a0a944.png' />" \
            '</a>' \
            '</span>'
        end
        return_val += '</div>'
        unless person.institution.nil?
          return_val += "<div class='csu-institution'>#{person.institution}</div>"
        end
        return_val += '</div>'

        return_val
      end
    end
  end
end
