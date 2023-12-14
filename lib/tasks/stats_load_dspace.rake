# frozen_string_literal: true

require 'csv'

# Usage:
# bundle exec rake calstate:stats_load_dspace['/home/ec2-user/data/dspace',downloads]

namespace :calstate do
  desc 'Load historical usage stats from file'
  task :stats_load_dspace, %i[dir_path stat_type] => [:environment] do |_t, args|
    dir_path = args[:dir_path] or raise 'No directory specified.'
    stat_type = args[:stat_type] or raise 'No stat type specified.'

    Dir.foreach(dir_path) do |file_path|
      next if %w[. ..].include?(file_path)
      z = 0

      file = File.open(dir_path + '/' + file_path)
      lines = file.readlines.map(&:chomp)

      lines.each do |line|
        row = line.split("\t")
        stat = if stat_type == 'views'
                 StatsWorkView.new
               elsif stat_type == 'downloads'
                 StatsFileDownload.new
               else
                 raise 'stat_type must be wither "views" or "download"'
               end

        x = stat_type == 'downloads' ? 0 : -1

        stat.file_id = row[x] if stat_type == 'downloads'
        stat.work_id = row[x + 1]
        stat.campus = row[x + 2]

        stat.ip_address = row[x + 3]
        stat.user_agent = row[x + 4]
        stat.created_at = row[x + 5]
        stat.country = row[x + 6]
        stat.city = row[x + 7]
        stat.latitude = row[x + 8]
        stat.longitude = row[x + 9]

        stat.user_agent.squish!
        stat.source = 'dspace'

        next if StatsService.bad_user_agent?(stat.user_agent)

        stat.save!
        z += 1
        puts file_path + "\t" + stat.work_id + "\t" + z.to_s
      end

      file.close
    end
  end
end
