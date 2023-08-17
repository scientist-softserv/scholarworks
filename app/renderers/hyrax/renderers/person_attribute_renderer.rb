#
# Special rendering to display name, institution, and ORCID for composite person type for scholarworks work with name as text
#
module Hyrax
  module Renderers
    class PersonAttributeRenderer < AttributeRenderer
      include PersonAttribute
    end
  end
end
