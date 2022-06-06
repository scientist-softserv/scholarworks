# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# input file should have three columns with headers for:
#   id, work_visibility, file_visibility
# use internal visibility name, e.g.: 'open' instead of 'public'
#
# bundle exec rake calstate:visibility[/home/ec2-user/data/import/file.csv]
#
namespace :calstate do
  desc 'Import new work from CSV file'
  task :visibility, %i[campus file] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'No campus provided.'
    file = args[:file] or raise 'No csv file provided.'

    packager = CalState::Packager::Visibility.new(campus)
    packager.process_items(file)
  end
end

