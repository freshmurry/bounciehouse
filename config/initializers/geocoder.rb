Geocoder.configure(
  lookup: :google,                  # Service to use for geocoding
  api_key: ENV['GEOCODER_API_KEY'], # Your API key
  timeout: 15,                      # Timeout in seconds
  units: :km                        # Units of measurement
)
