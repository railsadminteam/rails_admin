source 'http://rubygems.org'

gem 'rails', '~> 3.1'
gem 'devise', '~> 1.4'
gem 'rails_admin', :path => '../../'
gem 'mlb', '~> 0.5'
gem 'paperclip', '~> 2.4'
gem 'mini_magick'
gem 'carrierwave'
gem 'dragonfly'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.1'
  gem 'coffee-rails', '~> 3.1'
  gem 'uglifier', '~> 1.0'
end

group :development, :test do
  platforms :jruby do
    gem 'jruby-openssl', '~> 0.7'
    # activerecord-jdbc-adapter does not yet have a rails 3.1 compatible release
    gem 'activerecord-jdbc-adapter', :git => 'git://github.com/jruby/activerecord-jdbc-adapter.git'
    case ENV['CI_DB_ADAPTER']
    when 'mysql'
      gem 'activerecord-jdbcmysql-adapter', '~> 1.1'
      gem 'jdbc-mysql', '~> 5.1'
    when 'postgresql'
      gem 'activerecord-jdbcpostgresql-adapter', '~> 1.1'
      gem 'jdbc-postgres', '~> 9.0'
    else
      gem 'activerecord-jdbcsqlite3-adapter', '~> 1.1'
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
end

platforms :jruby, :mingw_18, :ruby_18 do
  gem 'fastercsv', '~> 1.5'
end
