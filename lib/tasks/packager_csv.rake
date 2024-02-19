# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:csv[qn59q426c,losangeles,scholarworks@calstate.edu,'/home/ec2-user/data/new/losangeles.csv']
# bundle exec rake packager:csv[qn59q426c,losangeles,scholarworks@calstate.edu,'/home/ec2-user/data/new/losangeles.csv',true]
# bundle exec rake packager:csv[qn59q426c,losangeles,scholarworks@calstate.edu,'/home/ec2-user/data/new/losangeles.csv',false,5]
#
namespace :packager do
  desc 'Import new work from CSV file'
  task :csv, %i[admin_set campus depositor file metadata_only throttle] => [:environment] do |_t, args|
    admin_set = args[:admin_set] or raise 'No admin set provided'
    campus = args[:campus] or raise 'No campus provided.'
    depositor = args[:depositor] or raise 'No depositor provided.'
    file = args[:file] or raise 'No csv file provided.'

    throttle = args[:throttle] ||= 0
    metadata_only = args[:metadata_only] ||= false

    packager = CalState::Packager::Csv.new(admin_set, campus, depositor)
    packager.metadata_only = metadata_only == 'true'
    packager.throttle = throttle
    packager.process_items(file)
  end
end

