# frozen_string_literal: true

require 'csv'

# Usage
# bundle exec rake calstate:delete_records[sacramento]
# bundle exec rake calstate:delete_records[/home/ec2-user/data/remove.csv]

namespace :calstate do
  desc 'Delete records'
  task :delete_records, %i[source] => [:environment] do |_t, args|
    source = args[:source] or raise 'Must provide campus or file path.'

    if CampusService.all_campus_slugs.include?(source)
      CalState::Metadata.models.each do |model|
        count = model.where(campus: source).count.to_s
        puts 'Deleting ' + model.to_s + ' (found ' + count + ')'
        puts "\n"

        model.where(campus: source).each do |work|
          print "\n" + work.id + '. . . '
          work.destroy
          print 'deleted.'
        end
      end
    elsif File.exist?(source)
      options = { headers: true, encoding: 'bom|utf-8' }

      CSV.read(source, options).each do |row|
        id = row['id']

        begin
          print "\n" + id + ' . . . '
          work = ActiveFedora::Base.find(id)
          work.destroy
          print 'deleted.'
        rescue ActiveFedora::ObjectNotFoundError
          print 'not found.'
        rescue Ldp::Gone
          print 'already deleted.'
        rescue Ldp::HttpError => e
          raise e unless e.message.include?('Cannot locate child node')

          print "couldn't locate child node."
        end
      end
    else
      raise 'Did not specify (recognized) campus or file.'
    end
  end
end
