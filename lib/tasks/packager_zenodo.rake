# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:zenodo[fullerton,10]
#

namespace :packager do
  desc 'Migrate Zenodo packages to Hyrax'
  task :zenodo, %i[campus throttle] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus provided.'
    throttle = args[:throttle] ||= nil

    packager = CalState::Packager::Zenodo.new(campus)
    packager.process_items(throttle)
  end
end
