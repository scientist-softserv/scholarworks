module Hyrax 
  module Renderers
    class DisciplineAttributeRenderer < FacetedAttributeRenderer
      def li_value(value)
        discipline = DisciplineService::DISCIPLINES[value]
        return '' if discipline.nil?
        return link_to(ERB::Util.h(discipline.name), search_path(value)) if discipline.ancestor.empty?

        discipline_path = ''
        discipline.ancestor.each do |ancestor_id|
          ancestor = DisciplineService::DISCIPLINES[ancestor_id]
          next if ancestor.nil?

          discipline_path += link_to(ERB::Util.h(ancestor.name), search_path(ancestor_id)) + ' > '
        end

        discipline_path += link_to(ERB::Util.h(discipline.name), search_path(value))
        discipline_path
      end
    end
  end
end
