# frozen_string_literal: true

require 'calstate/metadata'

# Usage
# bundle exec rake calstate:embargo_lift

namespace :calstate do
  desc 'Embargo lifter'
  task embargo_lift: :environment do
    solr_reader = CalState::Metadata::Solr::Reader.new
    expired_embargoes = solr_reader.records_with_expired_embargoes

    puts 'Found ' + expired_embargoes.count.to_s + ' expired embargoes.'

    expired_embargoes.each do |doc|
      id = doc['id']

      # make sure we have a work
      work = ActiveFedora::Base.find(id)
      # work = work.parent if work.is_a?(FileSet)

      # make sure the embargo is active and before today
      next if work.embargo.embargo_release_date.nil?
      next unless work.embargo.embargo_release_date <= Date.today

      print id + ': . . . '

      # remove embargo on work (replicates EmbargoActor)
      work.embargo_visibility!
      work.deactivate_embargo!
      work.embargo.save!
      work.save!

      # make sure the files get the new visibility as well
      VisibilityCopyJob.new.perform(work)

      print "done!\n"
    end
  end
end
