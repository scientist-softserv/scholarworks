# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:islandora[mosslanding,Thesis]
# bundle exec rake packager:islandora[sandiego,Publication,restricted]

namespace :packager do
  desc 'Migrate Landing moss packages to Hyrax'
  task :islandora, %i[campus type visibility] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus provided.'
    type = args[:type] ||= 'Thesis'
    visibility = args[:visibility] ||= 'open'

    packager = CalState::Packager::Islandora.new(campus, type, visibility)
    packager.process_items
  end
end
