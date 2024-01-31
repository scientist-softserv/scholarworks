# frozen_string_literal: true

require 'calstate/metadata'
require 'csv'

# Usage:
# bundle exec rake calstate:work_report[/home/ec2-user/data/works.csv]

namespace :calstate do
  desc 'Work and file count report'
  task :work_report, %i[file] => [:environment] do |_t, args|
    export_file = args[:file] or raise 'Please provide path for export file.'

    # get all the files
    files = {}
    file_sets = CalState::Metadata::Solr::Reader.new(models:['FileSet']).records
    file_sets.each do |file|
      files[file.get('id')] = file
    end

    # get all the works
    works = CalState::Metadata::Solr::Reader.new.records

    # create the csv file
    CSV.open(export_file, 'wb') do |csv|
      csv << %w[ID handle campus files file_ids size]
      works.each do |doc|

        # make sure the handle is actually a handle
        handle = nil
        doc.get('handle').each do |url|
          handle = url if url.include?('handle.net')
        end

        # extract the name, id, and size of files from the fileset
        file_names = []
        file_ids = []
        size_of_files = 0

        doc.get('file_set_ids').each do |file_id|
          if files.include?(file_id)
            file_set = files[file_id]
            file_names.append file_set.get('title').first.to_s
            file_ids.append file_set.get('id')
            size_of_files += file_set.get('file_size').to_i
          end
        end

        # now assemble the line for the csv
        values = [
          doc.get('id'),
          handle,
          doc.get('campus').first.to_s
        ]
        values.append file_names.join('|')
        values.append file_ids.join('|')
        values.append size_of_files

        # write to csv
        csv << values
      end
    end
  end
end
