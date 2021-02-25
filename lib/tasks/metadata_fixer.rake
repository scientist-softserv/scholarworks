# frozen_string_literal: true

require 'calstate/metadata'

namespace :calstate do
  desc 'Metadata fixer'
  task metadata_fixer: :environment do
    fix = CalState::Metadata::Fixer.new
    # do something
  end
end
