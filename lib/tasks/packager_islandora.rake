# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:islandora[qn59q426c,mosslanding,scholarworks@calstate.edu]
# bundle exec rake packager:islandora[qn59q426c,mosslanding,scholarworks@calstate.edu,180]
#
namespace :packager do
  desc 'Islandora importer'
  task :islandora, %i[campus admin_set depositor throttle] => [:environment] do |_t, args|
    admin_set = args[:admin_set] or raise 'No admin_set provided.'
    campus = args[:campus] or raise 'No campus provided.'
    depositor = args[:depositor] or raise 'No depositor provided.'
    throttle = args[:throttle] ||= 0

    packager = CalState::Packager::Islandora.new(campus, admin_set, depositor)
    packager.throttle = throttle
    packager.rename_folders
    packager.process_items
  end
end
