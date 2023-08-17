#
# User model
#
class User < ApplicationRecord
  include Hydra::User
  include Hydra::RoleManagement::UserRoles
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
    raise 'Single sign-on not working for this campus.' if auth.info.campus.empty?

    where(uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.display_name = auth.info.name
      #user.password = Devise.friendly_token[0, 20]
      user.uid = auth.uid
      user.affiliation = auth.info.affiliation
      user.campus = auth.info.campus

      # mlml uses the sjsu auth but is its own campus
      if auth.info.campus == 'sjsu' && auth.info.department == '1153'
        user.campus = 'mlml'
      end
    end
  end

  #
  # Full campus name
  #
  def campus_name
    CampusService.get_name_from_slug(campus_slug)
  end

  #
  # Campus slug
  #
  def campus_slug
    if ENV['AUTHENTICATION_TYPE'] == 'shibboleth'
      CampusService.get_shib_user_campus(self)
    else
      CampusService.get_demo_user_campus(self)
    end
  end

  def preferred_locale
    nil
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    email
  end

  # Mailboxer (for Notifications) needs the User object to respond to
  # his method in order to send uses_emails
  def mailboxer_email(_object)
    email
  end

  #
  # Is this user a manager?
  #
  # @return [Boolean]
  #
  def manager?
    groups.each do |group|
      return true if group.include?('managers-')
    end
    false
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
