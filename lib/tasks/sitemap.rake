# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:sitemap

namespace :calstate do
  desc 'Sitemap generator'
  task sitemap: :environment do
    CalState::Metadata::Sitemap.new.run
  end
end
