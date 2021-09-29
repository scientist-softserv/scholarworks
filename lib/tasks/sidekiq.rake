# frozen_string_literal: true
#
# bundle exec rake calstate:sidekiq
#

namespace :calstate do
  desc 'Report of all sidekiq jobs'
  task sidekiq: :environment do
    types = {}
    queue = Sidekiq::Queue.new(:ingest)
    queue.each do |job|
      type = job.item['wrapped']

      job.delete if type == 'FixityCheckJob'

      if types.key?(type)
        types[type] += 1
      else
        types[type] = 1
      end
    end
    pp types
  end
end
