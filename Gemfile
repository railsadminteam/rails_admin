source 'http://rubygems.org'

gemspec

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  if 'java' == RUBY_PLATFORM
    gem 'activerecord-jdbc-adapter', '~> 1.1', :platform => :jruby
    gem 'jdbc-sqlite3', '~> 3.6', :platform => :jruby
  else
    gem 'sqlite3-ruby', '~> 1.3'
  end
end
