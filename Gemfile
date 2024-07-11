

source 'https://rubygems.org'

gem 'appraisal', '>= 2.0'
gem 'devise', '~> 4.7'
gem 'net-smtp', require: false
gem 'rails'
gem 'sassc-rails', '~> 2.1'
gem 'turbo-rails'
gem 'vite_rails', require: false
gem 'webpacker', require: false
gem 'webrick'

group :development, :test do
  gem 'pry', '>= 0.9'
end

group :test do
  gem 'cancancan', '~> 3.0'
  gem 'carrierwave', ['>= 2.0.0.rc', '< 3']
  gem 'cuprite', '!= 0.15.1'
  gem 'database_cleaner-active_record', '>= 2.0', require: false
  gem 'database_cleaner-mongoid', '>= 2.0', require: false
  gem 'dragonfly', '~> 1.0'
  gem 'factory_bot', '>= 4.2', '!= 6.4.5'
  gem 'generator_spec', '>= 0.8'
  gem 'kt-paperclip'
  gem 'launchy', '>= 2.2'
  gem 'mini_magick', '>= 3.4'
  gem 'pundit'
  gem 'rack-cache', require: 'rack/cache'
  gem 'rspec-expectations', '!= 3.8.3'
  gem 'rspec-rails', '>= 4.0.0.beta2'
  gem 'rspec-retry'
  gem 'rubocop', ['~> 1.20', '!= 1.22.2'], require: false
  gem 'rubocop-performance', require: false
  gem 'shrine', '~> 3.0'
  gem 'simplecov', '>= 0.9', require: false
  gem 'simplecov-lcov', require: false
  gem 'timecop', '>= 0.5'

  # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
  gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
end

group :active_record do
  gem 'paper_trail', '>= 12.0'

  platforms :ruby, :mswin, :mingw, :x64_mingw do
    gem 'mysql2', '>= 0.3.14'
    gem 'pg', '>= 1.0.0'
    gem 'sqlite3', '~> 1.3'
  end
end

group :mongoid do
  gem 'cancancan-mongoid'
  gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
  gem 'kaminari-mongoid'
  gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
  gem 'shrine-mongoid', '~> 1.0'
end

gemspec
