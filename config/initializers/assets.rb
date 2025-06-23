# config/initializers/assets.rb

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Since we're using Tailwind via CDN, no need to precompile application.tailwind.css
# Rails.application.config.assets.precompile += %w( application.tailwind.css )

# Add node_modules to the assets paths so that we can include packages like Tailwind
Rails.application.config.assets.paths << Rails.root.join('node_modules')

Rails.application.config.assets.configure do |env|
  # Register mime type for .scss files (in case you want to handle them as CSS)
  env.register_mime_type 'text/css', extensions: ['.css', '.scss'], charset: :unicode
  
  # Register the compressor for SCSS files using sassc
  env.register_compressor 'text/css', :sassc, { mime_type: 'text/css' }

  # Tailwind is handled by the CDN, so no need for specific Tailwind handling here
  # If you were manually using PostCSS for Tailwind, you would add those configurations here
end
