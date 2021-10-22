# frozen_string_literal: true

require 'calstate/metadata'

# Usage
# bundle exec rake calstate:visibility_split
# bundle exec rake calstate:visibility_split[sacramento]

namespace :calstate do
  desc 'Make record public but keep files restricted'
  task :visibility_split, %i[campus] => [:environment] do |_t, args|
    campus = args[:campus] ||= nil
    name = if campus.nil?
             nil
           else
             Hyrax::CampusService.get_campus_name_from_id(campus)
           end

    # find restricted results from solr
    reader = CalState::Metadata::SolrReader.new
    results = reader.find_restricted_records(name)
    puts "Found #{results.count} records that are restricted."

    results.each do |solr_doc|
      print 'Processing work ' + solr_doc['id'] + ' . . . '

      begin
        # get the fedora object
        work = ActiveFedora::Base.find(solr_doc['id'])

        # set visibility to public
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
