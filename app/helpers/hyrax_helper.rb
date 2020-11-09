module HyraxHelper
  include ::BlacklightHelper
  include Hyrax::BlacklightOverride
  include Hyrax::HyraxHelperBehavior

  def visibility_badge(value)
    CampusPermissionBadge.new(value).render
  end

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
end
