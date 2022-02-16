# frozen_string_literal: true

# Usage
# bundle exec rake calstate:user[create,'new@calstate.edu','password']
# bundle exec rake calstate:user[update,'exists@calstate.edu','password']

namespace :calstate do
  desc 'Create or  update user password'
  task :user, %i[action email password] => [:environment] do |_t, args|
    action = args[:action] or raise 'Must supply action'
    email = args[:email] or raise 'Must supply username'
    password = args[:password] or raise 'Must supply password'

    # see if it exists already
    users = User.where(email: email)

    if action == 'update'
      if users.count.zero?
        puts "Couldn't find user <#{email}>"
      else
        user = users.first
        user.password = password
        user.password_confirmation = password
        puts "User <#{email}> updated" if user.save!
      end
    elsif action == 'create'
      if users.count.positive?
        puts "Whoops, user <#{email}> already exists!"
      else
        user = User.new
        user.uid = email
        user.email = email
        user.password = password
        user.password_confirmation = password
        puts "User <#{email}> created" if user.save!
      end
    else
      puts "Action needs to be 'update' or 'create', you supplied '#{action}'."
    end
  end
end

# fix all current users to include uid
#
# User.all.each do |u|
#   u.uid = u.email
#   u.save
# end
