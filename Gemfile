# frozen_string_literal: true

source 'https://rubygems.org'

gem 'appraisal', '>= 2.0'
gem 'devise'
gem 'net-smtp', require: false
gem 'rails'
gem 'webpacker', require: false
gem 'webrick', '~> 1.7'

group :active_record do
  gem 'paper_trail'

  platforms :ruby, :mswin, :mingw, :x64_mingw do
    gem 'mysql2', '>= 0.3.14'
    gem 'sqlite3', '>= 1.3'
  end
end

group :development, :test do
  gem 'pry', '>= 0.9'
end

group :test do
  gem 'cancancan', '~> 3.0'
  gem 'carrierwave', ['>= 2.0.0.rc', '< 3']
  gem 'cuprite'
  gem 'database_cleaner-active_record', '>= 2.0', require: false
  gem 'database_cleaner-mongoid', '>= 2.0', require: false
  gem 'dragonfly', '~> 1.0'
  gem 'factory_bot', '>= 4.2'
  gem 'generator_spec', '>= 0.8'
  gem 'launchy', '>= 2.2'
  gem 'mini_magick', '>= 3.4'
  gem 'pundit'
  gem 'rack-cache', require: 'rack/cache'
  gem 'rspec-expectations', '!= 3.8.3'
  gem 'rspec-rails', '>= 2.14'
  gem 'rspec-retry'
  gem 'rubocop', ['~> 1.20', '!= 1.22.2'], require: false
  gem 'rubocop-performance', require: false
  gem 'simplecov', '>= 0.9', require: false
  gem 'simplecov-lcov', require: false
  gem 'timecop', '>= 0.5'

  # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
  gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
end

gemspec
