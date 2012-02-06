HourschoolV2::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # set cloudfront url to serve assets from
  # ENV["cloudfront_url"] can be set per server (i.e. staging/etc.)
  config.action_controller.asset_host = ENV["cloudfront_url"] || "http://d1ufsa5oa5lbkj.cloudfront.net"

  config.static_cache_control = "public, max-age=2592000"

  # Generate digests for assets URLs
  config.assets.digest = true

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false
  config.action_controller.asset_host = "http://d1ufsa5oa5lbkj.cloudfront.net"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => 'hourschool.com' }
  ### ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"
end
