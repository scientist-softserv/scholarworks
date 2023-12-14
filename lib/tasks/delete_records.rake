# frozen_string_literal: true

require 'csv'

# Usage
# bundle exec rake calstate:delete_records[/home/ec2-user/data/remove.csv]

namespace :calstate do
  desc 'Delete records'
  task :delete_records, %i[source] => [:environment] do |_t, args|
    source = args[:source] or raise 'Must provide path to file of records to delete.'
    raise 'Could not find file.' unless File.exist?(source)

    co_admin = AdminSet.where(title: 'Chancellor')&.first&.id
    options = { headers: true, encoding: 'bom|utf-8' }

    CSV.read(source, options).each do |row|
      id = row['id'].squish

      begin
        print "\n#{id} . . . "
        work = ActiveFedora::Base.find(id)
        work.file_sets.each(&:destroy!)
        work.destroy
        print 'deleted.'
      rescue ActiveFedora::ObjectNotFoundError
        print 'not found.'
      rescue Ldp::Gone
        print 'already deleted.'
      rescue Ldp::HttpError => e
        raise e unless e.message.include?('Cannot locate child node')

        print "couldn't locate child node, so reassigning record to Chancellor."

        # make a note of it first
        campus = work.campus.first
        notes = work.description_note.to_a
        notes.append 'Campus was ' + campus
        work.description_note = notes

        # update campus and visibility
        work.campus = ['Chancellor']
        work.admin_set_id = co_admin unless co_admin.nil?
        work.visibility = 'restricted'
        work.save
      end
    end

    puts "\n"
  end
end
