source 'https://rubygems.org'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :active_record do
  platforms :jruby do
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'activerecord-jdbcmysql-adapter', '~> 1.2'
      gem 'jdbc-mysql', '~> 5.1'
    when 'postgresql'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.2'
      gem 'jdbc-postgres', '~> 9.0'
    else
      gem 'activerecord-jdbcsqlite3-adapter', '~> 1.2'
      gem 'jdbc-sqlite3', '~> 3.6'
    end
  end

  platforms :ruby, :mswin, :mingw do
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'mysql', '~> 2.8'
    when 'postgresql'
      gem 'pg', '~> 0.13'
    else
      gem 'sqlite3', '~> 1.3'
    end
  end
  gem 'carrierwave'
end

group :mongoid do
  gem 'bson_ext', :platforms => [:ruby, :mswin, :mingw]
  case ENV['CI_ORM_VERSION']
  when 'head'
    gem 'mongoid', :git => 'git://github.com/mongoid/mongoid.git'
    # For now, carrierwave-mongoid's mongoid dependency is restricted to '~> 2.1'
    gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid', :git => 'git://github.com/tanordheim/carrierwave-mongoid.git', :branch => 'mongoid_3_0'
  else
    gem 'mongoid'
    gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
  end
  gem 'mongoid-paperclip', :require => 'mongoid_paperclip'
end

group :debug do
  platform :mri_18 do
    gem 'ruby-debug'
    gem 'linecache'
  end

  platform :mri_19 do
    gem 'ruby-debug19'
    gem 'simplecov', :require => false
  end

  platform :jruby do
    gem 'ruby-debug'
  end
end

platforms :jruby, :mingw_18, :ruby_18 do
  gem 'fastercsv', '~> 1.5'
end

group :development, :test do
  gem 'cancan'
  gem 'devise'
  gem 'paperclip', '~> 2.7'
end

gemspec
