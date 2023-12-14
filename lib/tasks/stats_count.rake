# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:stats_count

namespace :calstate do
  desc 'Campus counts for works'
  task stats_count: :environment do
    campuses = {}
    CampusService.all_campus_names.each do |campus|
      campuses[campus] = 0
      CalState::Metadata.models.each do |model|
        campuses[campus] += model.where(campus: campus).count
      end
    end
    campuses.each do |campus,count|
      puts campus + "\t" + count.to_s
    end
  end
end
