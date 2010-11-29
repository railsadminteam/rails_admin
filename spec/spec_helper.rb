# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start do
  add_filter '/config/'
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'lib'
  add_group 'Specs', 'spec'
end

require File.expand_path('../dummy_app/config/environment', __FILE__)
require "rails/test_help"
require "rspec/rails"

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "test.com"

Rails.backtrace_cleaner.remove_silencers!

# Run any available migration
ActiveRecord::Migrator.migrate File.expand_path('../dummy_app/db/migrate/', __FILE__)

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each{|f| require f}

Webrat.configure do |config|
  config.mode = :rails
end

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers
  require 'rspec/expectations'

  config.include RSpec::Matchers
  config.include Webrat::Matchers
  config.include Webrat::HaveTagMatcher

  # == Mock Framework
  config.mock_with :rspec
end
