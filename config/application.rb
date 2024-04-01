require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Bravado
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.active_job.queue_adapter = :sidekiq
    config.eager_load_paths << Rails.root.join('lib')
    config.middleware.use Rack::CrawlerDetect
    Rails.application.routes.default_url_options[:host] = ENV['SCHOLARWORKS_HOST']

    config.to_prepare do
      Hyrax::CurationConcern.actor_factory.insert_after Hyrax::Actors::DefaultAdminSetActor, Hyrax::Actors::AssignCampusActor

      # Allows us to use decorator files
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")).sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      Dir.glob(File.join(File.dirname(__FILE__), "../lib/**/*_decorator*.rb")).sort.each do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # metaprogramming makes decorating hard
      c = File.join(File.dirname(__FILE__), '../lib/wings/orm_converter.rb')
      Rails.configuration.cache_classes ? require(c) : load(c)
    end
  end
end
