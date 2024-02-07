# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:metadata_export[losangeles]
# bundle exec rake calstate:metadata_export[all]

namespace :calstate do
  desc 'Export metadata csv for a campus'
  task :metadata_export, %i[campus] => [:environment] do |_t, args|
    campus = args[:campus] or raise 'No campus provided.'
    csv_dir = '/data/tmp/exports'
    zip_dir = '/data/exports/metadata'

    campuses = if campus == 'all'
                 CampusService.all_campus_slugs
               else
                 [campus]
               end

    puts "Writing CSV files."

    campuses.each do |campus|
      print campus + ': '
      csv_writer = CalState::Metadata::Csv::Writer.new(csv_dir, campus)

      csv_writer.write_all
      print "exported"

      csv_writer.zip_all(zip_dir)
      print ", zipped.\n"
    end
  end
end
