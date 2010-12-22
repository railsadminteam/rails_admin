source 'http://rubygems.org'

gemspec

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  if 'java' == RUBY_PLATFORM
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'jdbc-mysql', '~> 5.1'
      gem 'activerecord-jdbcmysql-adapter', '~> 1.1'
    when 'postgresql'
      gem 'jdbc-postgres', '~> 8.4'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.1'
    else
      gem 'jdbc-sqlite3', '~> 3.6'
      gem 'activerecord-jdbcsqlite3-adapter', '~> 0.9'
    end
  else
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'mysql', '~> 2.8'
    when 'postgresql'
      gem 'pg', '~> 0.10'
    else
      gem 'sqlite3-ruby', '~> 1.3'
    end
  end
end
