source 'https://rubygems.org'

case ENV['RAILS_VERSION']
when '4.0'
  gem 'rails', '~> 4.0.0'
  gem 'devise', '>= 3.2'
  gem 'test-unit'
when '4.1'
  gem 'rails', '~> 4.1.0'
  gem 'devise', '>= 3.2'
else
  gem 'rails', '~> 4.2.0'
  gem 'sass-rails', '~> 5.0'
  gem 'devise', '>= 3.4'
end

case ENV['CI_ORM']
when 'mongoid'
  gem 'mongoid', '~> 4.0.0.beta1'
  gem 'mongoid-paperclip', '>= 0.0.8', require: 'mongoid_paperclip'
  gem 'carrierwave-mongoid', '>= 0.6.3', require: 'carrierwave/mongoid'
else
  platforms :jruby do
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'activerecord-jdbcmysql-adapter', '>= 1.2'
      gem 'jdbc-mysql', '>= 5.1'
    when 'postgresql'
      gem 'activerecord-jdbcpostgresql-adapter', '>= 1.2'
      gem 'jdbc-postgres', '>= 9.2'
    else
      gem 'activerecord-jdbcsqlite3-adapter', '>= 1.3.0.beta1'
      gem 'jdbc-sqlite3', '>= 3.7'
    end
  end

  platforms :ruby, :mswin, :mingw do
    case ENV['CI_DB_ADAPTER']
    when 'mysql2'
      gem 'mysql2', '~> 0.3.14'
    when 'postgresql'
      gem 'pg', '>= 0.14'
    else
      gem 'sqlite3', '>= 1.3'
    end
  end

  gem 'paper_trail', '~> 3.0'
end

group :development, :test do
  gem 'pry', '>= 0.9'
end

group :test do
  gem 'cancan', '>= 1.6'
  gem 'cancancan', '~> 1.9'
  gem 'capybara', '>= 2.1'
  gem 'carrierwave', '>= 0.8'
  gem 'coveralls'
  gem 'database_cleaner', ['>= 1.2', '!= 1.4.0']
  gem 'dragonfly', '~> 1.0'
  gem 'factory_girl', '>= 4.2'
  gem 'generator_spec', '>= 0.8'
  gem 'launchy', '>= 2.2'
  gem 'mini_magick', '>= 3.4'
  gem 'paperclip', '>= 3.4'
  gem 'poltergeist', '~> 1.5'
  gem 'rack-cache', require: 'rack/cache'
  gem 'rspec-rails', '>= 2.14'
  gem 'rubocop', '>= 0.25'
  gem 'simplecov', '>= 0.9', require: false
  gem 'timecop', '>= 0.5'
end

gemspec
