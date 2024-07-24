# Geocoder.configure(
#   units: :mi,
#   :timeout=>15
# )

# Geocoder::Configuration.timeout = 15

# Geocoder.configure(
#   # Geocoding options
#   lookup: :google,
#   api_key: ENV['GOOGLE_API_KEY'], # Set your API key here
#   timeout: 5
# )

Geocoder.configure(
  # Geocoding options
  lookup: :google,         # The geocoding service you want to use (Google, Bing, etc.)
  api_key: ENV['GOOGLE_API_KEY'], # Set your API key here (use an environment variable for security)
  timeout: 15,             # Timeout in seconds
  units: :mi,              # Distance units (options are :km or :mi)
  use_https: true,         # Use HTTPS for requests
  language: :en            # Language for results (optional)
)

# Optionally, you can configure other settings if needed