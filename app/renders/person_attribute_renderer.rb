require "rails_autolink/helpers"

module Hyrax
  module Renderers
    class PersonAttributeRenderer < AttributeRenderer

      def render
        markup = ''

        return markup if values.blank? && !options[:include_empty]
        markup << %(<tr><th>#{label}</th>\n<td><ul class='tabular'>)
        attributes = microdata_object_attributes(field).merge(class: "attribute attribute-#{field}")
        values.each do |value|
          person = value.split(":::")
          email = nil
          institution = nil
          orcid = nil
          name = person[0]
          if (person.length > 1)
            email = person[1]
            institution = person[2]
            orcid = person[3]
          end
          markup << "<li#{html_attributes(attributes)}>#{attribute_value_to_html(field.to_s, name, email, orcid, institution)}</li>"
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
          person = value.split(":::")
          email = nil
          institution = nil
          orcid = nil
          name = person[0]
          if (person.length > 1)
            email = person[1]
            institution = person[2]
            orcid = person[3]
          end
          markup << "<li#{html_attributes(attributes)}>#{attribute_value_to_html(field.to_s, name, email, orcid, institution)}</li>"
        end
        markup << %(</ul></dd>)
        markup.html_safe
      end

      private

      def attribute_value_to_html(person_type, name, email, orcid, institution)
        return_val = "<span#{html_attributes(microdata_value_attributes(field))}>#{li_value(name)}</span>";
        return_val += "&nbsp;<a href='mailto:#{email}'><i class='fa fa-envelope' aria-hidden='true'></i> Email<span class='sr-only'> to " + person_type + " #{name}</span></a>" unless email.nil?
        return_val += "&nbsp;<a target='_blank' href='https://orcid.org/#{orcid}'><img alt='ORCID profile for " + person_type + " #{name}' class='profile' src='/assets/orcid-cb273c1ff10d304ce1b6108a172bfd1660561e7fd8133b083cd66ee0f4a0a944.png'></a>" unless orcid.nil?
        return_val += "<span style='font-size: 12px'>&nbsp;#{institution}</span>" unless institution.nil?
        return_val
      end

    end
  end
end
