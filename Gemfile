source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'awesome_print'
gem 'aws-sdk-s3'
gem 'blacklight_advanced_search'
gem 'blacklight_oai_provider'
gem 'blacklight_range_limit'
gem 'bootstrap-sass', '~> 3.0'
gem 'bulkrax'
gem 'chronic'
gem 'coffee-rails', '~> 4.2'
gem 'colorize'
gem 'config'
gem 'crawler_detect'
gem 'devise', '>= 4.4.0'
gem 'devise-guests', '~> 0.6'
gem 'handle-system-rest'
gem 'hydra-derivatives', '~>3.6'
gem 'hydra-role-management'
gem 'hyrax', '3.6'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'maxmind-geoip2'
gem 'okcomputer', '~> 1.18', '>= 1.18.4'
gem 'omniauth-shibboleth'
gem 'pg', '~> 0.18'
gem 'rails', '~> 5.2'
gem 'redis', '~> 4.0'
gem 'riiif', '~> 2.1'
gem 'rsolr', '>= 1.0', '< 3'
gem 'rubocop'
gem 'ruby-vips', '~> 2.0'
gem 'rubyzip'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'solargraph'
gem 'table_print'
gem 'turbolinks', '~> 5'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'
gem 'willow_sword', github: 'csuscholarworks/willow_sword', tag: 'v1.0'
gem 'yaml_extend'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.15'
  gem 'dotenv-rails', require: 'dotenv/rails-now'
  gem 'factory_bot_rails'
  gem 'fcrepo_wrapper'
  gem 'puma', '~> 3.11'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'solr_wrapper', '>= 0.3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec-sidekiq'
end

group :production do
  gem 'passenger', '>= 5.0.25', require: 'phusion_passenger/rack_handler'
end
