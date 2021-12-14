# frozen_string_literal: true

require 'calstate/metadata'

# Usage
# bundle exec rake calstate:visibility_split
# bundle exec rake calstate:visibility_split[sacramento]
# bundle exec rake calstate:visibility_split[sacramento,/home/ec2-user/data/import/file.csv]

namespace :calstate do
  desc 'Make record public but keep files restricted'
  task :visibility_split, %i[campus file] => [:environment] do |_t, args|
    campus = args[:campus] ||= nil
    file = args[:file] ||= nil
    name = if campus.nil?
             nil
           else
             Hyrax::CampusService.get_campus_name_from_slug(campus)
           end

    # find restricted results from solr query or file
    results = if file.nil?
                reader = CalState::Metadata::SolrReader.new
                reader.find_restricted_records(name)
              else
                CSV.open(file, { headers: true })
              end
    # puts "Found #{results.count} records that are restricted."

    results.each do |record|
      print 'Processing work ' + record['id'] + ' . . . '

      begin
        work = ActiveFedora::Base.find(record['id'])

        # set visibility of work to public
        work.visibility = 'open'

        # remove embargo on work (replicates EmbargoActor)
        unless work.embargo&.embargo_release_date.nil?
          work.embargo_visibility!
          work.deactivate_embargo!
          work.embargo.save!
          work.save!
          abort
        end

        work.save!
      rescue Ldp::Gone
        print '[ GONE! ] . . . '
      rescue ActiveFedora::ObjectNotFoundError
        print '[ NOT FOUND! ] . . . '
      end

      print "done!\n"
    end
  end
end
