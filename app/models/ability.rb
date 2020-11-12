class Ability
  include Hydra::Ability
  include Hyrax::Ability

  self.ability_logic += [:everyone_can_create_curation_concerns]

  # Define any customized permissions here.
  def custom_permissions
    campus = "bakersfield" if current_user.campus == "csub"
    campus = "chancellor" if current_user.campus == "co"
    campus = "channel" if current_user.campus == "csuci"
    campus = "chico" if current_user.campus == "csuchico"
    campus = "dominguez" if current_user.campus == "csudh"
    campus = "eastbay" if current_user.campus == "csueastbay"
    campus = "fresno" if current_user.campus == "csufresno"
    campus = "fullerton" if current_user.campus == "fullerton"
    campus = "humboldt" if current_user.campus == "humboldt"
    campus = "longbeach" if current_user.campus == "csulb"
    campus = "losangeles" if current_user.campus == "calstatela"
    campus = "maritime" if current_user.campus == "csum"
    campus = "monterey" if current_user.campus == "csumb"
    campus = "mlml" if current_user.campus == "mlml"
    campus = "northridge" if current_user.campus == "csun"
    campus = "pomona" if current_user.campus == "csupomona"
    campus = "sacramento" if current_user.campus == "csus"
    campus = "sanbernardino" if current_user.campus == "csusb"
    campus = "sandiego" if current_user.campus == "sdsu"
    campus = "sanfrancisco" if current_user.campus == "sfsu"	
    campus = "sanjose" if current_user.campus == "sjsu"	
    campus = "slo" if current_user.campus == "calpoly"	
    campus = "sanmarcos" if current_user.campus == "csusm"	
    campus = "sonoma" if current_user.campus == "sonoma"	
    campus = "stanislaus" if current_user.campus == "csustan"

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
