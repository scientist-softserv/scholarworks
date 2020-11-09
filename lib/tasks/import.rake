# frozen_string_literal: true

require 'calstate/metadata'

namespace :calstate do
  desc 'Import metadata csv for a campus'
  task :import, %i[file] => [:environment] do |_t, args|
    csv_file = args[:file] or raise 'No import file provided.'
    CalState::Metadata::Csv::Updater.new.update_records(csv_file)
  end
end
