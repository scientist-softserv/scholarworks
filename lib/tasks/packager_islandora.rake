# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:islandora[mosslanding,Thesis]
# bundle exec rake packager:islandora[sandiego,Publication,180]

namespace :packager do
  desc 'Islandora importer'
  task :islandora, %i[campus type throttle] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'No campus provided.'
    type = args[:type] ||= 'Thesis'
    throttle = args[:throttle] ||= nil

    packager = CalState::Packager::Islandora.new(campus, type)
    packager.throttle = throttle.to_i
    packager.rename_folders
    packager.process_items
  end
end
