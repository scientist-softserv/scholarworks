# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:metadata_export[losangeles]

namespace :calstate do
  desc 'Export metadata csv for a campus'
  task :metadata_export, %i[campus] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'No campus provided.'
    csv_dir = '/home/ec2-user/data/exported'

    csv_writer = CalState::Metadata::Csv::Writer.new(csv_dir, campus)
    csv_writer.write_all
  end
end
