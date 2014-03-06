source 'http://rubygems.org'
source 'https://BnrJb6FZyzspBboNJzYZ@gem.fury.io/govuk/'

#ruby=ruby-1.9.3
#ruby-gemset=quirkafleeg-panopticon

gem 'dotenv-rails'

gem 'plek', '1.5.0'
gem 'formtastic', git: 'https://github.com/justinfrench/formtastic.git', branch: '2.1-stable'
gem 'formtastic-bootstrap', git: 'https://github.com/cgunther/formtastic-bootstrap.git', branch: 'bootstrap-2'

gem 'nested_form', '0.3.2'


gem 'ansi'
gem 'gelf'
gem 'null_logger'

gem 'exception_notification'

gem 'gds-api-adapters', :github => 'theodi/gds-api-adapters'

gem 'aws-ses', require: 'aws/ses'

gem 'rails', '3.2.13'
gem 'foreman'
gem 'thin'
gem 'less-rails-bootstrap'

gem 'colorize', '~> 0.5.8'
gem 'rummageable', "~> 0.3.0"

gem "mongoid", "~> 2.5"
gem "mongoid_rails_migrations", "1.0.0"
gem "mongo", "1.7.1"
gem "kaminari", "0.14.1"
gem "bson_ext", "1.7.1"
gem "bson", "1.7.1"
gem 'lograge', '~> 0.1.0'

gem 'language_list'

gem 'govuk_content_models', '5.14.0'

if ENV['CONTENT_MODELS_DEV']
  gem "odi_content_models", path: '../odi_content_models'
else
  gem "odi_content_models", github: 'theodi/odi_content_models'
end

if ENV['BUNDLE_DEV']
  gem 'gds-sso', path: '../gds-sso'
else
  gem 'gds-sso', '~> 3.0.5'
end

gem 'jquery-rails', '2.0.2'
gem 'jquery-ui-rails', '3.0.1'

group :assets do
  gem "therubyracer", "~> 0.12.0"
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
  gem 'database_cleaner'
  gem 'minitest'
  gem "shoulda", "~> 2.11.3"
  gem 'factory_girl', "3.3.0"
  gem 'factory_girl_rails'
  gem 'capybara', '1.1.2'
  gem 'capybara-mechanize', '~> 0.3.0.rc3'
  gem 'launchy'
  gem 'mocha', '0.13.3', :require => false
  gem 'webmock', require: false
  gem 'poltergeist', '0.7.0'
  gem 'pry'
end

group :import do
  gem 'nokogiri'
end
