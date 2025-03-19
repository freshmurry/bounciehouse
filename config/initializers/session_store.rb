# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_pinteresting_2_session'
Rails.application.config.session_store :cookie_store, 
  key: '_BouncieHouse_session', 
  same_site: :none,  # or :strict, :lax, depending on your use case
  secure: Rails.env.production?  # Only send cookies over HTTPS in production