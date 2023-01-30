# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:file_export

namespace :calstate do
  desc 'Export files from works'
  task file_export: :environment do
    campus = 'Chico'
    year_range = (2009..2016)

    CalState::Metadata.models.each do |model|
      year_range.each do |year|
        puts '============='
        puts year.to_s
        puts '============='
        model.where(campus: campus, date_issued_year: year.to_s).each do |work|
          puts "#{work.date_issued_year}: #{work.title.first}"
          puts "making dir `#{work.id}`"

          work_dir = "/home/ec2-user/data/chico/#{work.id}"
          next if Dir.exist?(work_dir)

          Dir.mkdir(work_dir)

          work.file_sets.each do |file|
            file_name = "#{work_dir}/#{file.title.first}"
            content = file.association(:original_file).reader.content
            encoding = content.encoding.name
            File.write(file_name, content.force_encoding(encoding), encoding: encoding)
          end
        end
      end
    end
  end
end
