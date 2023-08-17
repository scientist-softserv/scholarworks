# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:dspace[qn59q426c,sacramento,scholarworks@calstate.edu,'ITEM@10211.3-133542.zip']
# bundle exec rake packager:dspace[qn59q426c,losangeles,scholarworks@calstate.edu,items]
# bundle exec rake packager:dspace[qn59q426c,losangeles,scholarworks@calstate.edu,items,60]
#
namespace :packager do
  desc 'DSpace importer'
  task :dspace, %i[admin_set campus depositor file throttle] => [:environment] do |_t, args|
    admin_set = args[:admin_set] or raise 'No admin_set provided.'
    campus = args[:campus] or raise 'No campus provided.'
    depositor = args[:depositor] or raise 'No depositor provided.'
    source_file = args[:file] or raise 'No zip file provided.'
    throttle = args[:throttle] ||= 0

    packager = CalState::Packager::Dspace.new(admin_set, campus, depositor)
    packager.throttle = throttle

    if source_file == 'items'
      packager.process_items
    else
      packager.process_package(source_file)
    end
  end
end

