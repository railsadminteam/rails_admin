source 'https://rubygems.org'

group :active_record do
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
      gem 'mysql2', '~> 0.3.11'
    when 'postgresql'
      gem 'pg', '>= 0.14'
    else
      gem 'sqlite3', '>= 1.3'
    end
  end
end

group :mongoid do
  gem 'mongoid', github: 'mongoid/mongoid'
  gem 'mongoid-paperclip', '>= 0.0.8', :require => 'mongoid_paperclip'
  gem 'mongoid-grid_fs', github: 'ahoward/mongoid-grid_fs'
  gem 'carrierwave-mongoid', github: 'jnicklas/carrierwave-mongoid', :require => 'carrierwave/mongoid'
end

group :development do
  gem 'pry', '>= 0.9'
  gem 'pry-debugger', '>= 0.2', :platforms => :mri_19
end

group :test do
  gem 'cancan', '>= 1.6'
  gem 'capybara', '~> 2.0'
  gem 'carrierwave', '>= 0.8'
  gem 'coveralls', :require => false
  gem 'database_cleaner', '~> 1.0.0' # https://github.com/bmabey/database_cleaner/issues/224
  gem 'devise', '~> 3.0.0.rc'
  gem 'dragonfly', '>= 0.9'
  gem 'rack-cache', :require => 'rack/cache'
  gem 'factory_girl', '>= 4.2'
  gem 'generator_spec', '>= 0.8'
  gem 'launchy', '>= 2.2'
  gem 'mini_magick', '>= 3.4'
  gem 'paperclip', '>= 3.4'
  gem 'poltergeist', :github => 'jonleighton/poltergeist'
  gem 'rspec-rails', '>= 2.14'
  gem 'simplecov', :require => false
  gem 'timecop', '>= 0.5'
end

gemspec
