# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:islandora[mosslanding,Thesis]
# bundle exec rake packager:islandora[sandiego,Publication,180]

namespace :packager do
  desc 'Migrate Landing moss packages to Hyrax'
  task :islandora, %i[campus type visibility] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus provided.'
    type = args[:type] ||= 'Thesis'
    throttle = args[:visibility] ||= nil

    packager = CalState::Packager::Islandora.new(campus, type)
    packager.rename_folders
    packager.process_items(throttle)
  end
end
