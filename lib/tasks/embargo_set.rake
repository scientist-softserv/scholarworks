# frozen_string_literal: true

require 'calstate/metadata'

# Usage
#
# bundle exec rake calstate:embargo_set[/home/ec2-user/data/import/file.csv]

namespace :calstate do
  desc 'Set embargoes on work and files'
  task :embargo_set, %i[input] => [:environment] do |_t, args|
    input = args[:input] ||= ''

    # find restricted results from file, otherwise solr
    results = CSV.open(input, { headers: true })

    results.each do |record|
      print "Processing work #{record['id']} . . . "

      begin
        work = ActiveFedora::Base.find(record['id'])
        work.embargo_release_date = record['embargo_release_date']
        work.visibility_during_embargo = record['visibility_during_embargo']
        work.visibility_after_embargo = record['visibility_after_embargo']
        work.save!

        work.file_sets.each do |file|
          file.embargo_release_date = record['embargo_release_date']
          file.visibility_during_embargo = record['visibility_during_embargo']
          file.visibility_after_embargo = record['visibility_after_embargo']
          file.save!
        end

      rescue Ldp::Gone
        print '[ GONE! ] . . . '
      rescue ActiveFedora::ObjectNotFoundError
        print '[ NOT FOUND! ] . . . '
      end

      print "done!\n"
    end
  end
end
