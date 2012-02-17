# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start 'rails'

ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true'
require File.expand_path('../dummy_app/config/environment', __FILE__)

require 'generator_spec/test_case'
require 'generators/rails_admin/install_generator'
require 'generators/rails_admin/uninstall_generator'
require 'rspec/rails'
require 'factory_girl'
require 'factories'
require 'database_helpers'
require 'generator_helpers'

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "example.com"

Rails.backtrace_cleaner.remove_silencers!

include DatabaseHelpers
# Run any available migration
puts 'Setting up database...'
drop_all_tables
migrate_database
ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'false'
# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each{|f| require f}

# Don't need passwords in test DB to be secure, but we would like 'em to be
# fast -- and the stretches mechanism is intended to make passwords
# computationally expensive.
module Devise
  module Models
    module DatabaseAuthenticatable
      protected

      def password_digest(password)
        password
      end
    end
  end
end
Devise.setup do |config|
  config.stretches = 0
end

RSpec.configure do |config|
  require 'rspec/expectations'

  config.include RSpec::Matchers
  config.include DatabaseHelpers
  config.include GeneratorHelpers
  config.include RailsAdmin::Engine.routes.url_helpers

  config.include Warden::Test::Helpers

  config.before(:each) do
    RailsAdmin::Config.reset
    RailsAdmin::AbstractModel.reset
    RailsAdmin::Config.excluded_models = [RelTest, FieldTest, Category]
    RailsAdmin::Config.audit_with :history
    Category.delete_all
    Division.delete_all
    Draft.delete_all
    Fan.delete_all
    League.delete_all
    Player.delete_all
    Team.delete_all
    User.delete_all
    Foo::Bar.delete_all
    FieldTest.delete_all
    login_as User.create(
      :email => "username@example.com",
      :password => "password"
    )
  end

  config.after(:each) do
    Warden.test_reset!
  end
end
