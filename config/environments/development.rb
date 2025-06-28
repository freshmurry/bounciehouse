Rails.application.configure do
  config.action_controller.forgery_protection_origin_check = false

  # Code is reloaded on every request.
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  # Caching toggle based on file presence
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

  config.after_initialize do
    ActiveSupport::Deprecation.silenced = true
  end

  # Raise error if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # === Choose ONE Mailer Delivery Method ===

  # Option A: Use letter_opener (recommended for local dev)
  # config.action_mailer.delivery_method = :letter_opener

  # Option B: Use Mailgun SMTP (if testing real sends in dev)
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'smtp.mailgun.org',
    port: 2525,
    domain: 'sandbox849ca54dc98b42888da6976e40db3c35.mailgun.org',
    authentication: 'plain',
    user_name: 'postmaster@sandbox849ca54dc98b42888da6976e40db3c35.mailgun.org',
    password: '20e436f9190a67c9fbb9b852ab52cae8'
  }

  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Asset handling
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.assets.quiet = true

  # Migrations
  config.active_record.migration_error = :page_load
  config.active_support.deprecation = :log

  # File watcher
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Action Cable
  config.action_cable.mount_path = '/cable'
  config.action_cable.url = 'ws://localhost:3000/cable'

  # Web Console
  config.web_console.allowed_ips = '10.0.2.2'

  # Optional: Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end