source 'https://rubygems.org'

gem 'appraisal', '>= 2.0'
gem 'devise'

group :active_record do
  platforms :jruby do
    gem 'activerecord-jdbcmysql-adapter', '>= 1.2'
    gem 'jdbc-mysql', '>= 5.1'
    gem 'activerecord-jdbcpostgresql-adapter', '>= 1.2'
    gem 'jdbc-postgres', '>= 9.2'
    gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.beta1'
    gem 'jdbc-sqlite3', '>= 3.7'
  end

  platforms :ruby, :mswin, :mingw do
    gem 'mysql2', '~> 0.3.14'
    gem 'pg', '>= 0.14'
    gem 'sqlite3', '>= 1.3'
  end
end

group :development, :test do
  gem 'pry', '>= 0.9'
end

group :test do
  gem 'cancan', '>= 1.6'
  gem 'cancancan', '~> 1.12.0'
  gem 'carrierwave', '>= 0.8'
  gem 'coveralls'
  gem 'database_cleaner', ['>= 1.2', '!= 1.4.0', '!= 1.5.0']
  gem 'dragonfly', '~> 1.0'
  gem 'factory_girl', '>= 4.2'
  gem 'generator_spec', '>= 0.8'
  gem 'launchy', '>= 2.2'
  gem 'mini_magick', '>= 3.4'
  gem 'paperclip', ['>= 3.4', '!= 4.3.0']
  gem 'poltergeist', '~> 1.5'
  gem 'pundit'
  gem 'rack-cache', require: 'rack/cache'
  gem 'rspec-rails', '>= 2.14'
  gem 'rubocop', '~> 0.41.2'
  gem 'simplecov', '>= 0.9', require: false
  gem 'timecop', '>= 0.5'

  platforms :ruby_19 do
    gem 'tins', '~> 1.6.0', require: false
  end
end

gemspec
