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
      gem 'activerecord-jdbcsqlite3-adapter', '>= 1.2'
      gem 'jdbc-sqlite3', '>= 3.7'
    end
  end

  platforms :ruby, :mswin, :mingw do
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'mysql', '~> 2.8.1'
    when 'postgresql'
      gem 'pg', '>= 0.14'
    else
      gem 'sqlite3', '>= 1.3'
    end
  end
end

group :mongoid do
  gem 'mongoid', '>= 3.0'
  gem 'mongoid-paperclip', '>= 0.0.8', :require => 'mongoid_paperclip'
  gem 'carrierwave-mongoid', '>= 0.4', :require => 'carrierwave/mongoid'
end

group :development do
  gem 'pry', '>= 0.9'
  gem 'pry-debugger', '>= 0.2', :platforms => :mri_19
end

group :test do
  gem 'cancan', '>= 1.6'
  gem 'capybara', '~> 1.1'
  gem 'carrierwave', '>= 0.8'
  gem 'coveralls', :require => false
  gem 'database_cleaner', '>= 0.8'
  gem 'devise', '>= 2.1'
  gem 'dragonfly', '>= 0.9'
  gem 'factory_girl', '>= 4.2'
  gem 'generator_spec', '>= 0.8'
  gem 'launchy', '>= 2.2'
  gem 'mini_magick', '>= 3.4'
  gem 'paperclip', '>= 3.4'
  gem 'rspec-rails', '>= 2.11'
  gem 'simplecov', :require => false
  gem 'strong_parameters', '>= 0.1.6'
  gem 'timecop', '>= 0.5'
end

gemspec
