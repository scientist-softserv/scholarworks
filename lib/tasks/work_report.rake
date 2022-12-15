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
      csv << %w[ID handle campus files file_ids size]
      CalState::Metadata.models.each do |model|
        model.all.each do |doc|
          handle = nil
          doc.handle.each do |url|
            handle = url if url.include?('handle.net')
          end

          file_names = []
          file_ids = []
          size_of_files = 0

          doc.file_sets.each do |file|
            file_names.append file.title.first.to_s
            file_ids.append file.id
            size = file.association(:original_file)&.reader&.file_size
            size_of_files += size.first.to_i unless size.nil?
          end

          values = [
            doc.id,
            handle,
            doc.campus.first.to_s
          ]
          values.append file_names.join('|')
          values.append file_ids.join('|')
          values.append size_of_files

          csv << values
        end
      end
    end
  end
end
