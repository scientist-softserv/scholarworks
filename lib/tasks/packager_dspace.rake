# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:dspace[sacramento,'ITEM@10211.3-133542.zip']
# bundle exec rake packager:dspace[losangeles,items]
# bundle exec rake packager:dspace[losangeles,items,60]

namespace :packager do
  desc 'Migrate DSpace AIP packages to Hyrax'
  task :dspace, %i[campus file throttle] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus provided.'
    source_file = args[:file] or raise 'No zip file provided.'
    throttle = args[:throttle] or 0

    packager = CalState::Packager::Dspace.new(campus)
    packager.throttle = throttle.to_i

    if source_file == 'items'
      packager.process_items
    else
      packager.process_package(source_file)
    end
  end
end

