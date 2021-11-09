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
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
    Rails.logger.warn groups.inspect
    groups.each do |group|
      return true if group.include?('managers-')
    end
    false
  end
end
