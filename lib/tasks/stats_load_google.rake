# frozen_string_literal: true

require 'csv'

# Usage:
# bundle exec rake calstate:stats_load_google['/home/ec2-user/data/views.csv',views]

namespace :calstate do
  desc 'Load historical usage stats from file'
  task :stats_load_google, %i[file_path stat_type] => [:environment] do |_t, args|
    file_path = args[:file_path] or raise 'No file specified.'
    stat_type = args[:stat_type] or raise 'No stat type specified.'

    CSV.open(file_path, 'r', headers: true, col_sep: "\t").each do |row|
      stat = if stat_type == 'views'
               StatsWorkView.new
             elsif stat_type == 'downloads'
               StatsFileDownload.new
             else
               raise 'stat_type must be wither "views" or "download"'
             end

      stat.file_id = row['file_id'] if row.key?('file_id')
      stat.work_id = row['work_id']
      stat.campus = row['campus']

      stat.user_agent = row['user_agent']
      stat.created_at = row['created_at']
      stat.ip_address = row.key?('ip_address') ? row['ip_address'] : '0.0.0.0.'
      stat.country = row['country'] if row.key?('country')
      stat.city = row['city'] if row.key?('city')
      stat.latitude = row.key?('latitude') ? row['latitude'] : 0
      stat.longitude = row.key?('longitude') ? row['longitude'] : 0

      stat.source  = 'google'

      stat.save!
      puts row['work_id']
    end
  end
end
