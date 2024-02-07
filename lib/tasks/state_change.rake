# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:state_change[00ABC123]

namespace :calstate do
  desc "Force a record into active state."
  task :state_change, %i[work_id state] => [:environment] do |_t, args|
    work_id = args[:work_id] or raise 'No work ID provided.'
    work = ActiveFedora::Base.find(work_id)
    work.state = Vocab::FedoraResourceStatus.active
    work.save!
  end
end
