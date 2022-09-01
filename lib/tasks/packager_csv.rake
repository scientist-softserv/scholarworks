# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:csv[losangeles,'/home/ec2-user/data/new/losangeles.csv']
# bundle exec rake packager:csv[losangeles,'/home/ec2-user/data/new/losangeles.csv',true]
# bundle exec rake packager:csv[losangeles,'/home/ec2-user/data/new/losangeles.csv',false,5]
# # bundle exec rake packager:csv[losangeles,'/home/ec2-user/data/new/losangeles.csv',false,admin@calstate.edu]
#
namespace :packager do
  desc 'Import new work from CSV file'
  task :csv, %i[campus file metadata_only throttle depositor] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'No campus provided.'
    file = args[:file] or raise 'No csv file provided.'
    throttle = args[:throttle] or 0
    metadata_only = args[:metadata_only] or false
    depositor = args[:depositor] or nil

    packager = CalState::Packager::Csv.new(campus)
    packager.metadata_only = metadata_only
    packager.depositor = depositor unless depositor.nil?
    packager.throttle = throttle.to_i
    packager.process_items(file)
  end
end

