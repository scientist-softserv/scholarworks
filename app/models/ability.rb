class Ability
  include Hydra::Ability
  include Hyrax::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns]

  # Define any customized permissions here.
  def custom_permissions
    use_shib = ENV['AUTHENTICATION_TYPE'] == 'shibboleth'
    campus = if use_shib
               Hyrax::CampusService.get_shib_user_campus(current_user)
             else
               Hyrax::CampusService.get_demo_user_campus(current_user)
             end
    user_groups.push(campus) if campus.present?

    # add campus name to demo accounts if not already set
    if !use_shib && @current_user.campus.blank? && !@current_user.id.blank?
      Rails.logger.warn @current_user.inspect
      @current_user.campus = campus
      @current_user.save!
    end

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
