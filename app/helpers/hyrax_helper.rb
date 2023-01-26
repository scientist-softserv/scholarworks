module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def visibility_badge(value)
    CampusPermissionBadge.new(value).render
  end

  # add campus visibility
  def visibility_options(variant)
    options = [
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC,
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED,
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_CAMPUS,
      Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    ]
    case variant
    when :restrict
      options.delete_at(0)
      options.reverse!
    when :loosen
      options.delete_at(3)
    end
    options.map { |value| [visibility_text(value), value] }
  end

  # we only use English
  def available_translations
    {
      'en' => 'English'
    }
  end

  # use pipe instead of // as separator
  def construct_page_title(*elements)
    (elements.flatten.compact + [application_name]).join(' | ')
  end

  # handle catalog title separately
  def default_page_title
    if controller_name == 'catalog'
      title_parts = []
      query = params['q']
      title_parts.append(query) unless query.blank?
      if params.key?('f')
        facets = []
        params['f'].each do |key, value|
          field = t("blacklight.search.fields.facet.#{key}")
          facets.append "#{field}: #{value.join(', ')}".squish
        end
        title_parts.append(facets.join(', '))
      end

      text = title_parts.join(' | ')
      text = 'Search' if text.blank?
    else
      text = controller_name.singularize.titleize
      text = "#{action_name.titleize} " + text if action_name
    end

    construct_page_title(text)
  end
end
