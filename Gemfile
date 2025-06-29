source 'https://rubygems.org'
ruby '3.2.3'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '7.0.8'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 4.0.2'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'delayed_job'
gem 'rails-assets-jquery', :source => 'https://rails-assets.org/'
gem 'activeadmin'

group :development, :test do
  gem 'dotenv-rails'
end

group :development do
  gem 'sqlite3', '~> 1.4'
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem "bootstrap-sass", ">= 3.4.1"
gem "devise", ">= 4.6.0"

gem 'toastr-rails'
gem 'omniauth', '~> 1.6'
gem 'omniauth-facebook', '~> 4.0'

gem 'paperclip', '~> 6.1'
gem 'aws-sdk-s3'

gem 'geocoder', '~> 1.8'
gem 'jquery-ui-rails', '~> 5.0'

gem 'ransack'
gem 'puma'
gem 'figaro'
gem 'redis', '~> 4.0'

group :production do
  gem 'pg', '~> 1.1'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  # Adding database cleaner for tests
  gem 'database_cleaner'
end

gem 'capistrano'

#----  AirKONG  -------
gem 'twilio-ruby', '~> 4.11.1'
gem 'fullcalendar-rails', '~> 3.4.0'
gem 'momentjs-rails', '~> 2.17.1'
gem 'stripe', '~> 3.0.0'
gem 'rails-assets-card', source: 'https://rails-assets.org'
gem 'omniauth-stripe-connect', '~> 2.10.0'
gem "chartkick", '>= 3.2.0'
gem 'sitemap_generator'

gem 'mimemagic', '~> 0.3.10'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'bcrypt', '~> 3.1.7'
gem 'byebug', '>= 4.2.6', platform: :mri
gem 'coffee-script'
gem 'sassc-rails'
gem 'mini_racer'