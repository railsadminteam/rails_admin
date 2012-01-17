source 'https://rubygems.org'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'foo', :path => './spec/dummy_app/foo'
  gem 'rails_admin_custom_field', :git => 'git://github.com/bbenezech/rails_admin_custom_field.git'
  
  platforms :jruby do
    gem 'jruby-openssl', '~> 0.7'
    # activerecord-jdbc-adapter does not yet have a rails 3.1 compatible release
    gem 'activerecord-jdbc-adapter', :git => 'git://github.com/jruby/activerecord-jdbc-adapter.git'
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
      gem 'pg', '~> 0.10'
    else
      gem 'sqlite3', '~> 1.3'
    end
  end

  gem 'cancan'
  gem 'silent-postgres'
end

group :debug do
  platform :mri_18 do
    gem 'ruby-debug'
    gem 'linecache'
  end

  platform :mri_19 do
    gem 'ruby-debug19'
  end
end

platforms :jruby, :mingw_18, :ruby_18 do
  gem 'fastercsv', '~> 1.5'
end

gemspec
