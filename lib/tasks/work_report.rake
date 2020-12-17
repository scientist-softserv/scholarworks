# Usage
# bundle exec rake calstate:work_report[campus]
# bundle exec rake calstate:work_report["San Francisco"]
#
#
require 'csv'

namespace :calstate do
  desc 'Work and file count report'
  task :work_report, %i[file] => [:environment] do |_t, args|
    export_file = args[:file] or raise 'Please provide a location for export CSV file.'

    CSV.open(export_file, 'wb') do |csv|
      csv << %w[ID handle campus files]
      CalState::Metadata.models.each do |model|
        model.all.each do |doc|
          begin
            values = [
              doc.id,
              doc.handle.first.to_s,
              doc.campus.first.to_s
            ]
            file_names = ''
            doc.file_sets.each do |file|
              file_names.concat('|') if !file_names.to_s.empty?
              file_names.concat(file.title.first.to_s)
            end
            values.push(file_names)
            csv << values
          rescue StandardError => e
            raise e
          end
        end
      end
    end
  end
end
