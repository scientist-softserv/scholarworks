# frozen_string_literal: true

require 'calstate/metadata'
require 'csv'

# Usage:
# bundle exec rake calstate:work_report[/home/ec2-user/data/works.csv]

namespace :calstate do
  desc 'Work and file count report'
  task :work_report, %i[file] => [:environment] do |_t, args|
    export_file = args[:file] or raise 'Please provide path for export file.'

    CSV.open(export_file, 'wb') do |csv|
      csv << %w[ID handle campus files file_ids]
      CalState::Metadata.models.each do |model|
        model.all.each do |doc|
          begin
            handle = nil
            doc.handle.each do |url|
              handle = url if url.include?('handle.net')
            end
            values = [
              doc.id,
              handle,
              doc.campus.first.to_s
            ]
            file_names = String.new
            file_ids = String.new
            doc.file_sets.each do |file|
              file_names.concat('|') unless file_names.to_s.empty?
              file_names.concat(file.title.first.to_s)

              file_ids.concat('|') unless file_ids.to_s.empty?
              file_ids.concat(file.id)
            end
            values.push(file_names)
            values.push(file_ids)
            csv << values
          rescue StandardError => e
            raise e
          end
        end
      end
    end
  end
end
