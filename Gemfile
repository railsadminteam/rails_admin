source 'http://rubygems.org'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'rails', '~> 3.0.0'

  platforms :jruby do
    gem 'jruby-openssl', '~> 0.7'
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'activerecord-jdbcmysql-adapter', '~> 1.1', :platform => :jruby
      gem 'jdbc-mysql', '~> 5.1', :platform => :jruby
    when 'postgresql'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.1', :platform => :jruby
      gem 'jdbc-postgres', '~> 9.0', :platform => :jruby
    else
      gem 'activerecord-jdbcsqlite3-adapter', '~> 1.1', :platform => :jruby
      gem 'jdbc-sqlite3', '~> 3.6', :platform => :jruby
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

  gem 'cancan' if ENV['AUTHORIZATION_ADAPTER'] == 'cancan'

  platform :rbx do
    gem 'nokogiri', '1.4.7' # Nokogiri 1.5.0 is incompatible with Rubinius 1.2.3
  end
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

gemspec
