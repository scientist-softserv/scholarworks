# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:metadata_fixer

namespace :calstate do
  desc 'Metadata fixer'
  task metadata_fixer: :environment do
    trans_file = '/home/ec2-user/data/import/all.xml'
    log_loc = '/home/ec2-user/data/import/'
    fixer = CalState::Metadata::Fixer::Tracker.new(trans_file, log_loc)
    fixer.run
  end
end
