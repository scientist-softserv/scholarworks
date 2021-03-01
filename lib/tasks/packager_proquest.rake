# frozen_string_literal: true

require 'calstate/packager'

# Usage:
# bundle exec rake packager:proquest

namespace :packager do
  desc 'Fix missing DSpace data from Proquest SWORD XML'
  task proquest: :environment do
    input_dir = '/data/exported/proquest'
    packager = CalState::Packager::Proquest.new
    packager.process_items(input_dir)
  end
end
