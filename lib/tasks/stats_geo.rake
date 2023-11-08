# frozen_string_literal: true

require 'calstate/metadata'

# Usage:
# bundle exec rake calstate:stats_geo

namespace :calstate do
  desc 'Enhance usage stats with GeoLite2 location data'
  task stats_geo: :environment do

    geo_database = '/usr/share/GeoIP/GeoLite2-City.mmdb'
    unless File.exist?(geo_database)
      raise "You can only run this task if the GeoLite2 database is installed at '#{geo_database}'"
    end

    reader = MaxMind::GeoIP2::Reader.new(database: geo_database)

    StatsWorkView.where(latitude: nil).each do |view|
      add_geo_data(reader, view)
    end

    StatsFileDownload.where(latitude: nil).each do |download|
      add_geo_data(reader, download)
    end
  end

  #
  # Add geo data to usage stats
  #
  # @param reader [MaxMind::GeoIP2::Reader]
  # @param stat [StatsWorkView or StatsFileDownload]
  #
  # @return [Boolean]  on success
  #
  def add_geo_data(reader, stat)
    geo = reader.city(stat.ip_address)

    stat.country = geo.country.iso_code
    stat.city = geo.city.name
    stat.latitude = geo.location.latitude
    stat.longitude = geo.location.longitude
    stat.save
  end
end
