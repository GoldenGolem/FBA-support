Rails.application.configure do
#vast-retreat-41955::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  # config.cache_classes = false

  # Do not eager load code on boot.
  # config.eager_load = false

  # Show full error reports and disable caching.  
  # config.consider_all_requests_local       = true
  
  # Don't care if the mailer can't send.
  # config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  

  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  config.log_level = :info
  # Enable Rack::Cache to put a simple HTTP cache in front of your application
  # Add `rack-cache` to your Gemfile before enabling this.
  # For large-scale production use, consider using a caching reverse proxy like nginx, varnish or squid.
  # config.action_dispatch.rack_cache = true

  # Disable Rails's static asset server (Apache or nginx will already do this).
  #config.serve_static_assets = true

  # Compress JavaScripts and CSS.
  #config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass

  # Do not fallback to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true
  config.action_controller.perform_caching = false

  # Generate digests for assets URLs.
  #config.assets.digest = true
  # config.action_mailer.default_url_options = { host: Rails.application.secrets.domain_name }
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.perform_deliveries = true
  # config.action_mailer.raise_delivery_errors = false
  # config.action_mailer.default :charset => "utf-8"

  # config.action_mailer.smtp_settings = {
  #   address: "smtp.gmail.com",
  #   port: 587,
  #   domain: Rails.application.secrets.domain_name,
  #   authentication: "plain",
  #   enable_starttls_auto: true,
  #   user_name: Rails.application.secrets.email_provider_username,
  #   password: Rails.application.secrets.email_provider_password
  # }

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true  
  
  logger           = ActiveSupport::Logger.new(STDOUT)
  logger.formatter = config.log_formatter
  config.logger = ActiveSupport::TaggedLogging.new(logger)

  config.action_mailer.smtp_settings = {
    :address        => 'email-smtp.us-west-2.amazonaws.com',
    :port           => '587',
    :authentication => :login,
    :user_name      => 'AKIAIAD7JQELR4KIDZ4Q',
    :password       => 'Ai7hwT82T7GWX1PGHQb2376e6OJWwZmyCHKyWVBXtbM6',
    :enable_starttls_auto => true
  }
end
