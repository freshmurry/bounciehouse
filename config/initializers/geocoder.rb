# Geocoder.configure(
#   units: :mi,
#   :timeout=>15
# )

Geocoder.configure(
  lookup: :google,
  api_key: ENV['AIzaSyCV181duH-y_7oW373c8YSHpUURXjKMKbk'],
  units: :mi,      
  use_https: true,   
  language: :en            
)