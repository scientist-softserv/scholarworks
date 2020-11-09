# frozen_string_literal: true

require 'calstate/metadata'

namespace :calstate do
  desc 'Sitemap generator'
  task sitemap: :environment do
    CalState::Metadata::Sitemap.new('public/sitemap').run
  end
end
