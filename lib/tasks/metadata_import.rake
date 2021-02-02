# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:metadata_import[sonoma]

namespace :calstate do
  desc 'Import metadata csv for a campus'
  task :metadata_import, %i[file] => [:environment] do |_t, args|
    csv_file = args[:file] or raise 'No import file provided.'
    CalState::Metadata::Csv::Updater.new.update_records(csv_file)
  end
end
