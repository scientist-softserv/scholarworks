# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:harvest[sacramento,180,2020-01-01]
#
namespace :packager do
  desc 'Harvest records for a specified campus that have been added or modified'
  task :harvest, %i[campus date delay] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'No campus provided.'
    throttle = args[:delay] ||= nil
    from = args[:date] ||= nil

    packager = CalState::Packager::Harvest.new(campus)
    packager.throttle = throttle unless throttle.nil?
    packager.process_items(from)
  end
end
