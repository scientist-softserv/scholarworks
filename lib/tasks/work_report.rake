# Usage
# bundle exec rake calstate:work_report[campus]
# bundle exec rake calstate:work_report["San Francisco"]
#
#
require 'csv'

namespace :calstate do
  desc 'Metadata replace'
  task :work_report, %i[campus] => [:environment] do |_t, args|
    campus_name = args[:campus] or raise 'No campus provided.'

    CSV.open('/home/ec2-user/export_report.csv', 'wb') do |csv|
      csv.to_io.write "\uFEFF" # BOM forces excel to treat file as UTF-8
      csv << ['ID', 'handle', 'file']
      CalState::Metadata.models.each do |model|
        model.where(campus: campus_name).each do |doc|
          begin
            values = [doc.id,
                  #    doc.campus.first,
                      doc.handle.first.to_s]
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
