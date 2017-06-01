source 'http://rubygems.org'

ruby "1.9.3"

gem 'dotenv-rails', '~> 1.0' # Fix to 1.x for rails 3

# Pinning this because we're still on 1.9.3 - can unpin once we get on new cookware
gem 'rack-cache', '< 1.3.0'

gem 'plek', '1.5.0'

gem 'nested_form', '0.3.2'
gem 'tagmanager-rails'

gem 'ansi'
gem 'gelf'
gem 'null_logger'

gem 'exception_notification', '~> 2.6'

gem 'gds-api-adapters', :github => 'theodi/gds-api-adapters'

gem 'aws-ses', require: 'aws/ses'

gem 'rails', '~> 3.2.22'
gem 'foreman', '< 0.65.0'
gem 'thin'

gem 'colorize', '~> 0.5.8'
gem 'rummageable', "1.0.1"

gem "mongoid", "~> 2.5"
gem "mongoid_rails_migrations", "1.0.1"
gem "mongo", "1.7.1"
gem "kaminari", "0.14.1"
gem "bson_ext", "1.7.1"
gem "bson", "1.7.1"
gem 'lograge', '~> 0.1.0'

gem 'language_list'

gem "govuk_content_models", "6.1.0"

gem 'memoist'
gem 'mongoid-tree'

if ENV['CONTENT_MODELS_DEV']
  gem "odi_content_models", path: '../odi_content_models'
else
  gem "odi_content_models", github: 'theodi/odi_content_models'
end

if ENV['BUNDLE_DEV']
  gem 'gds-sso', path: '../gds-sso'
else
  gem 'gds-sso', '9.2.2'
end

gem 'formtastic', '2.3.1'
gem 'formtastic-bootstrap', '2.1.3'

gem 'bootstrap-sass', '2.3.2.2'

gem 'jquery-rails', '2.0.2'
gem 'jquery-ui-rails', '3.0.1'
gem 'chosen-rails', '1.0.2'

group :assets do
  gem "therubyracer", "~> 0.12.0"
  gem 'sass-rails', '3.2.6'
  gem 'compass-rails', '1.1.2'
  gem 'uglifier'
end

group :development do
  gem 'quiet_assets'
end

group :test do
  # Pretty printed test output
  gem 'turn', require: false
  gem 'simplecov', '~> 0.6.4'
  gem 'simplecov-rcov'
  gem 'ci_reporter'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner', "~> 1.4.1"
  gem 'minitest'
  gem "shoulda", "~> 2.11.3"
  gem 'factory_girl', "3.3.0"
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'capybara-mechanize'
  gem 'launchy'
  gem 'mocha', '0.13.3', :require => false
  gem 'webmock', require: false
  gem 'poltergeist', '~> 1.5'
  gem 'pry'
end

group :import do
  gem 'nokogiri'
end

gem 'tunnels'

group :production do
  gem "rails_12factor"
  gem 'airbrake', '~> 4.3.4'
end