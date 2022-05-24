# frozen_string_literal: true

require 'calstate/metadata'
require 'hyrax'

#
# Usage:
# bundle exec rake calstate:collection_tree
#
namespace :calstate do
  desc 'Assign campus for collections based on depositor emails'
  task collection_tree: :environment do
    Kernel.const_get('Collection').where(depositor: '*').each do |user_collection|
      user_collection.campus = CampusService.get_demo_user_campus_name_from_email(user_collection.depositor)
      user_collection.save
    end
  end
end
