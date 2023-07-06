# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:harvest[qn59q426c,sacramento,scholarworks@calstate.edu,]
# bundle exec rake packager:harvest[qn59q426c,sacramento,scholarworks@calstate.edu,,2020-01-01]
# bundle exec rake packager:harvest[qn59q426c,sacramento,scholarworks@calstate.edu,,2020-01-01,180]
#
namespace :packager do
  desc 'Harvest records for a specified campus that have been added or modified'
  task :harvest, %i[admin_set campus depositor date throttle] => [:environment] do |_t, args|
    admin_set = args[:admin_set] or raise 'No admin set provided'
    campus = args[:campus] or raise 'No campus provided.'
    depositor = args[:depositor] or raise 'No depositor provided.'
    from = args[:date] ||= nil
    throttle = args[:throttle] ||= 0

    packager = CalState::Packager::Harvest.new(admin_set, campus, depositor)
    packager.throttle = throttle
    packager.process_items(from)
  end
end
