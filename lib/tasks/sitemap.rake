# frozen_string_literal: true

require 'calstate/metadata'

namespace :calstate do
  desc 'Sitemap generator'
  task sitemap: :environment do
    hyrax_url = 'https://' + ENV['SCHOLARWORKS_HOST']
    client = CalState::Metadata::SolrReader.new(hyrax_url, ENV['SOLR_URL'])
    client.build_sitemap('public/sitemap.xml')
  end
end
