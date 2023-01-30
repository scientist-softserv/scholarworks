source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 4.3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

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
gem 'passenger', '>= 5.0.25', require: 'phusion_passenger/rack_handler'
gem 'pg', '~> 0.18'
gem 'rails', '~> 5.2'
gem 'redis', '~> 3.0'
gem 'riiif', '~> 1.1'
gem 'rsolr', '>= 1.0'
gem 'rubocop'
gem 'ruby-vips', '~> 2.0'
gem 'rubyzip'
gem 'sass-rails', '~> 5.0'
gem 'solargraph'
gem 'table_print'
gem 'turbolinks', '~> 5'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'
gem 'yaml_extend'
gem 'willow_sword', github: 'csuscholarworks/willow_sword', tag: 'v1.0'

# Use sidekiq for background jobs in production
gem 'sidekiq'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara', '~> 2.13'
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
