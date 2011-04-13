source 'http://rubygems.org'

gemspec

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'rails', '~> 3.0.6.rc2'

  if 'java' == RUBY_PLATFORM
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
  else
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'mysql', '~> 2.8'
    when 'postgresql'
      gem 'pg', '~> 0.10'
    else
      gem 'sqlite3', '~> 1.3'
    end
  end
  gem "cancan" if ENV["AUTHORIZATION_ADAPTER"] == "cancan"
  gem 'factory_girl', '2.0.0.beta2'
  gem 'generator_spec'
end
