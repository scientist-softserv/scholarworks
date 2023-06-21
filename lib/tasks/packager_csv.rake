# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:csv[qn59q426c,losangeles,'/home/ec2-user/data/new/losangeles.csv']
# bundle exec rake packager:csv[qn59q426c,losangeles,'/home/ec2-user/data/new/losangeles.csv',true]
# bundle exec rake packager:csv[qn59q426c,losangeles,'/home/ec2-user/data/new/losangeles.csv',false,5]
# bundle exec rake packager:csv[qn59q426c,losangeles,'/home/ec2-user/data/new/losangeles.csv',false,0,admin@calstate.edu]
#
namespace :packager do
  desc 'Import new work from CSV file'
  task :csv, %i[admin_set campus file metadata_only throttle depositor] => [:environment] do |_t, args|
    admin_set = args[:admin_set] or raise 'No admin set provided'
    campus = args[:campus] or raise 'No campus provided.'
    file = args[:file] or raise 'No csv file provided.'
    throttle = args[:throttle] or 0
    metadata_only = args[:metadata_only] or false
    depositor = args[:depositor] or nil

    packager = CalState::Packager::Csv.new(campus, admin_set)
    packager.metadata_only = metadata_only == 'true'
    packager.depositor = depositor unless depositor.nil?
    packager.throttle = throttle.to_i
    packager.process_items(file)
  end
end

