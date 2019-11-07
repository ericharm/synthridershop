source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.2'

gem 'rails', '~> 5.2.3'
gem 'puma', '~> 3.11'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'figaro'
gem 'paypal-sdk-rest'

# db
gem 'sqlite3'
gem 'pg'
gem 'devise'

# attachments
gem 'carrierwave', '~> 1.0'
gem 'carrierwave-base64'
gem 'carrierwave-postgresql'
gem 'fog-aws'
gem 'zip-zip'

# front end
gem 'sass-rails', '~> 5.0'
gem 'materialize-sass', '~> 1.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'coffee-rails', '~> 4.2'

# deploy
gem 'capistrano3-nginx', '~> 2.0'
gem "capistrano-rails", "~> 1.4", require: false
gem 'capistrano-rvm'
gem 'capistrano-bundler', '~> 1.3'
gem 'capistrano-passenger'
gem 'capistrano'
gem 'capistrano-figaro-yml', '~> 1.0.2'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
