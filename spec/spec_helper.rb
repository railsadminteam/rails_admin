# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true'
require File.expand_path('../dummy_app/config/environment', __FILE__)

require 'rspec/rails'
require 'factory_girl'
require 'factories'
require 'database_helpers'

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "example.com"

Rails.backtrace_cleaner.remove_silencers!

include DatabaseHelpers
drop_all_tables
migrate_database
ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'false'

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
