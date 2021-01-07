class Ability
  include Hydra::Ability
  include Hyrax::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns]

  # Define any customized permissions here.
  def custom_permissions
    campus = if ENV['AUTHENTICATION_TYPE'] == 'shibboleth'
               Hyrax::CampusService.get_shib_user_campus(current_user)
             else
               Hyrax::CampusService.get_demo_user_campus(current_user)
             end
    user_groups.push(campus) if campus.present?

    user_groups.push(campus)

    # admin
    if current_user.admin?
      can [:create, :show, :add_user, :remove_user, :index, :edit, :update, :destroy], Role
    end

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end
end
