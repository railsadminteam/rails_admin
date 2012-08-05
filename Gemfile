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
  case ENV['CI_ORM_VERSION']
  when '2.4'
    platforms :ruby, :mswin, :mingw do
      gem 'bson_ext'
    end
    gem 'mongoid', '~> 2.4'
    gem 'mongoid-paperclip', :require => 'mongoid_paperclip'
    gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
  when 'head'
    gem 'mongoid', :git => 'git://github.com/mongoid/mongoid.git'
    gem 'mongoid-paperclip', :require => 'mongoid_paperclip', :git => 'git://github.com/meskyanichi/mongoid-paperclip.git', :branch => 'develop'
    gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid', :git => 'git://github.com/jnicklas/carrierwave-mongoid.git', :branch => 'mongoid-3.0'
  else
    gem 'mongoid', '~> 3.0.0'
    gem 'mongoid-paperclip', :require => 'mongoid_paperclip', :git => 'git://github.com/meskyanichi/mongoid-paperclip.git', :branch => 'develop'
    gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid', :git => 'git://github.com/jnicklas/carrierwave-mongoid.git', :branch => 'mongoid-3.0'
  end
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
  gem 'cancan', '1.6.7'
  gem 'devise'
  gem 'paperclip', '~> 2.7'
end

gemspec
