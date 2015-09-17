require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"
require "sass"
require "sprockets/railtie"
require 'kaminari' # has to be loaded before the models, otherwise the methods aren't added
require "govuk_content_models"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require *Rails.groups(:assets => %w(development test))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

require 'govuk/client/url_arbiter'

module Panopticon
  mattr_accessor :need_api
  mattr_accessor :whitehall_admin_api
  mattr_accessor :publisher_api

  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Enable the asset pipeline
    config.assets.enabled = true
    config.assets.version = '1.0'
    config.assets.prefix = '/assets'

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths += %W(#{config.root}/lib)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'London'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Disable Rack::Cache.
    config.action_dispatch.rack_cache = nil

    # Upon archiving an artefact we want this observer to run to remove
    # any related items that also point to that artefact.
    config.mongoid.observers << :remove_related_artefacts_observer

    # When saving a specialist sector tag we want to update the title of the
    # associated artefact
    config.mongoid.observers << :update_specialist_sector_tag_observer

    # When saving an artefact we want to send it to the router.
    config.mongoid.observers << :update_router_observer

    # When saving an artefact we want to update search.
    config.mongoid.observers << :update_search_observer

    def url_arbiter_api
      @url_arbiter_api ||= GOVUK::Client::URLArbiter.new
    end
  end
end
