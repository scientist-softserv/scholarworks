# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:dspace[losangeles,items]
# bundle exec rake packager:dspace[sacramento,'ITEM@10211.3-133542.zip']

namespace :packager do
  desc 'Migrate DSpace AIP packages to Hyrax'
  task :dspace, %i[campus file] => [:environment] do |_t, args|
    # error check
    campus = args[:campus] or raise 'No campus provided.'
    source_file = args[:file] or raise 'No zip file provided.'

    packager = CalState::Packager::Dspace.new(campus)

    if source_file == 'items'
      packager.process_items
    else
      packager.process_package(source_file)
    end
  end
end

