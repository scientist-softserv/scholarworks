# frozen_string_literal: true
#
# bundle exec rake calstate:jobs_report
#

namespace :calstate do
  desc 'Report of all job wrappers'
  task jobs_report: :environment do
    target = '/home/ec2-user/data/jobs.txt'
    File.open(target, 'w+') do |f|
      x = 0
      JobIoWrapper.all.each do |job|
        x += 1
        content = "\n=======================\n"
        content += x.to_s
        content += "\n=======================\n"
        content += job.pretty_inspect
        f.write(content)
      end
    end
  end
end
