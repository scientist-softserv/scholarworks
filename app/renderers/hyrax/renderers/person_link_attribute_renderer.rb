#
# Special rendering to display name, institution, and ORCID for composite person type for scholarworks work with name as link
#
module Hyrax
  module Renderers
    class PersonLinkAttributeRenderer < FacetedAttributeRenderer
      include PersonAttribute
    end
  end
end
