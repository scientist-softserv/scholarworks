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
gem 'chronic'
gem 'coffee-rails', '~> 4.2'
gem 'colorize'
gem 'config'
gem 'devise', '>= 4.4.0'
gem 'devise-guests', '~> 0.6'
gem 'handle-system-rest'
gem 'hydra-derivatives', '~>3.6'
gem 'hydra-role-management'
gem 'hyrax', '2.9.6'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'omniauth-shibboleth'
gem 'puma', '~> 4.3'
gem 'pg', '~> 0.18'
gem 'rails', '~> 5.2'
gem 'redis', '~> 3.0'
gem 'riiif', '~> 1.1'
gem 'rsolr', '>= 1.0'
gem 'rubocop'
gem 'ruby-vips', '~> 2.0'
gem 'rubyzip'
gem 'sass-rails', '~> 5.0'
gem 'sidekiq'
gem 'solargraph'
gem 'table_print'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'
gem 'yaml_extend'
gem 'willow_sword', github: 'csuscholarworks/willow_sword', tag: 'v1.0'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'factory_bot_rails'
  gem 'dotenv-rails', require: 'dotenv/rails-now'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'hyrax', '2.9.6'
gem 'hydra-role-management'
gem 'hydra-derivatives', '~>3.6'
gem 'omniauth-shibboleth'
# gem 'config'

group :development, :test do
  gem 'solr_wrapper', '>= 0.3'
end

gem 'rsolr', '>= 1.0'
gem 'jquery-rails'
gem 'devise', '>= 4.4.0'
gem 'devise-guests', '~> 0.6'
group :development, :test do
  gem 'fcrepo_wrapper'
  gem 'rspec-rails'
end

gem 'chronic'
gem 'riiif', '~> 1.1'
gem 'solargraph'
gem 'colorize'
gem 'rubyzip'
gem "ruby-vips", "~> 2.0"
gem 'handle-system-rest'
gem 'aws-sdk-s3'
gem 'blacklight_oai_provider'
gem 'blacklight_range_limit'
gem 'willow_sword', github: 'csuscholarworks/willow_sword', tag: 'v1.0'
gem 'rubocop'
