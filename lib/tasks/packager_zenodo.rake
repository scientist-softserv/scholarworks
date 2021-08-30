# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:zenodo[fullerton, 180]
#

namespace :packager do
  desc 'Migrate Zenodo packages to Hyrax'
  task :zenodo, %i[campus visibility] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus provided.'
    throttle = args[:visibility] ||= nil

    packager = CalState::Packager::Zenodo.new(campus)
    packager.process_items(throttle)
  end
end
