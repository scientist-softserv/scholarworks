# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:zenodo[cc08hg00q,fullerton,scholarworks@calstate.edu]
#
namespace :packager do
  desc 'Migrate Zenodo packages to Hyrax'
  task :zenodo, %i[admin_set campus depositor throttle] => [:environment] do |_t, args|
    admin_set = args[:admin_set] or raise 'No admin_set provided.'
    campus = args[:campus] or raise 'No campus provided.'
    depositor = args[:depositor] or raise 'No depositor provided.'
    throttle = args[:throttle] ||= nil

    packager = CalState::Packager::Zenodo.new(admin_set, campus, depositor)
    packager.throttle = throttle
    packager.process_items
  end
end
