# frozen_string_literal: true

require 'calstate/metadata'

#
# Usage:
# bundle exec rake calstate:assign_campus_collection
#
namespace :calstate do
  desc 'Assign campus for collections'
  task assign_campus_collection: :environment do
    Collection.where(campus: '').each do |coll|
      # get campus from depositor
      user = User.find_by_user_key(coll.depositor)
      campus = user.campus_name
      next if campus.blank?

      # set and update record
      puts "\n"
      puts "Updating Collection(#{coll.id}) to #{campus}."

      coll.reindex_extent = Hyrax::Adapters::NestingIndexAdapter::LIMITED_REINDEX
      coll.campus = [campus]
      coll.save!
    end
  end
end
