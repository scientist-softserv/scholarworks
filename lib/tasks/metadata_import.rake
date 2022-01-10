# frozen_string_literal: true

require 'calstate/metadata/csv'

# Usage:
# bundle exec rake calstate:metadata_import[eastbay_thesis]
# bundle exec rake calstate:metadata_import[fix]

namespace :calstate do
  desc 'Import metadata csv for a campus'
  task :metadata_import, %i[file] => [:environment] do |_t, args|
    file = args[:file] or raise 'No file specified.'

    file = "/home/ec2-user/data/import/transactions/#{file}.xml"
    updater = CalState::Metadata::Csv::Updater.new(file)
    updater.run
    updater.archive_file
  end
end
