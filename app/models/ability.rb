class Ability
  include Hydra::Ability
  include Hyrax::Ability

  # Define any customized permissions here.
  def custom_permissions
    use_shib = ENV['AUTHENTICATION_TYPE'] == 'shibboleth'

    # add user to campus group
    campus = if use_shib
               CampusService.get_shib_user_campus(current_user)
             else
               CampusService.get_demo_user_campus(current_user)
             end
    user_groups.push(campus) if campus.present?

    # add campus name to demo accounts if not already set
    if !use_shib && current_user.campus.blank? && !current_user.id.blank?
      current_user.campus = campus
      current_user.save!
    end

    # registered user can create works, files
    can :create, [FileSet] + Hyrax.config.curation_concerns if registered_user?

    # campus specific abilities
    cannot :create, [Project] if campus == 'sanmarcos'

    # managers & admins can also create collections
    can :create, Collection if manager? || current_user.admin?
    return unless current_user.admin?

    # admins can also manage roles
    can %i[create show add_user remove_user index edit update destroy], Role
  end

  #
  # Is this user part of a manager group
  #
  # @return [Boolean]
  #
  def manager?
    user_groups.each do |word|
      return true if word.include?('managers-')
    end
    false
  end
end
