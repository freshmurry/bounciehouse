Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  
   # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  
  config.action_controller.perform_caching = false
  
  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log
  
  # Send emails using letteropener in dev mode to open emails in a browser
  config.action_mailer.delivery_method = :letter_opener

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  config.assets.quiet = true
  
  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  
  config.web_console.whitelisted_ips = '10.0.2.2'
  
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.action_mailer.default_url_options = { host: 'https://88fa0413d4b4489f99e0338aec5db324.vfs.cloud9.us-east-1.amazonaws.com/' }

  # Mailgun Integration
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.mailgun.org',
    port: 2525,
    domain: 'sandbox849ca54dc98b42888da6976e40db3c35.mailgun.org',
    authentication: 'plain',
    user_name: 'postmaster@sandbox849ca54dc98b42888da6976e40db3c35.mailgun.org',
    password: '20e436f9190a67c9fbb9b852ab52cae8'
  }

end