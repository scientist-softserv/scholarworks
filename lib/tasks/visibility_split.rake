# frozen_string_literal: true

require 'calstate/metadata'

# Usage
# bundle exec rake calstate:visibility_split
# bundle exec rake calstate:visibility_split[sacramento]
# bundle exec rake calstate:visibility_split[/home/ec2-user/data/import/file.csv]

namespace :calstate do
  desc 'Make record public but keep files restricted'
  task :visibility_split, %i[input] => [:environment] do |_t, args|
    input = args[:input] ||= ''

    # find restricted results from file, otherwise solr
    results = if input.include?('/')
                CSV.open(input, { headers: true })
              else
                campus = input.empty? ? nil : CampusService.get_name_from_slug(input)
                reader = CalState::Metadata::Solr::Reader.new(campus: campus)
                reader.restricted_records
              end

    results.each do |record|
      print "Processing work #{record['id']} . . . "

      begin
        work = ActiveFedora::Base.find(record['id'])

        # permanently restricted records should be skipped
        if work.visibility == 'restricted' && work.embargo_release_date.blank?
          print "restricted, skipping!\n"
          next
        end

        # ensure files have correct visibility
        # (some migrated ones were not set correctly)
        VisibilityCopyJob.perform_now(work)

        # set visibility of work to public
        work.visibility = 'open'
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
