class User < ApplicationRecord
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Role-management behaviors.
  include Hydra::RoleManagement::UserRoles


  # Connects this user object to Hyrax behaviors.
  include Hyrax::User
  include Hyrax::UserUsageStats

  has_many :glacier_sns_download_requests



  if Blacklight::Utils.needs_attr_accessible?
    attr_accessible :email, :password, :password_confirmation
  end
  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :registerable, :recoverable, :validatable,
  # add :database_authenticatable for dev and test
  # :database_authenticatable
  devise :database_authenticatable, :rememberable, :trackable, :timeoutable, :omniauthable, omniauth_providers: [:shibboleth]

  def self.from_omniauth(auth)
    where(uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.display_name = auth.info.name
      #user.password = Devise.friendly_token[0, 20]
      user.uid = auth.uid
      user.affiliation = auth.info.affiliation
      user.campus = auth.info.campus

      # mlml uses the sjsu auth but is its own campus within scholarworks
      if auth.info.campus == 'sjsu' && auth.info.department == '1153'
        user.campus = 'mlml'
      end
    end
  end

  def preferred_locale
    return nil;
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  #Mailboxer (for Notifications) needs the User object to respond to this method in order to send uses_emails
  def mailboxer_email(_object)
    email
  end
end

# Override a Hyrax class that expects to create system users with passwords.
# Since in production we're using shibboleth, and this removes the password
# methods from the User model, we need to override it.
module Hyrax::User
  module ClassMethods
    def find_or_create_system_user(user_key)
      u = ::User.find_or_create_by(uid: user_key)
      u.display_name = user_key
      u.email = "#{user_key}@example.com"
      u.password = ('a'..'z').to_a.shuffle(random: Random.new).join.if ENV['AUTHENTICATION_TYPE'] == 'shibboleth'
      u.save
      u
    end
  end
end
