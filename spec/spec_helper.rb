# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"
ENV['SKIP_RAILS_ADMIN_INITIALIZER'] = 'true'
CI_ORM = (ENV['CI_ORM'] || :active_record).to_sym
CI_TARGET_ORMS = [:active_record, :mongoid]
PK_COLUMN = {:active_record=>:id, :mongoid=>:_id}[CI_ORM]

require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require File.expand_path('../dummy_app/config/environment', __FILE__)

require 'rspec/rails'
require 'factory_girl'
require 'factories'
require 'database_cleaner'
require "orm/#{CI_ORM}"

ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "example.com"

Rails.backtrace_cleaner.remove_silencers!

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
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RSpec::Matchers
  config.include RailsAdmin::Engine.routes.url_helpers

  config.include Warden::Test::Helpers

  config.include Capybara::DSL, type: :request

  config.before(:each) do
    DatabaseCleaner.start
    RailsAdmin::Config.reset
    RailsAdmin::AbstractModel.reset
    RailsAdmin::Config.audit_with(:history) if CI_ORM == :active_record
    RailsAdmin::Config.yell_for_non_accessible_fields = false
    login_as User.create(
      :email => "username@example.com",
      :password => "password"
    )
  end

  config.after(:each) do
    Warden.test_reset!
    DatabaseCleaner.clean
  end

  CI_TARGET_ORMS.each do |orm|
    if orm == CI_ORM
      config.filter_run_excluding "skip_#{orm}".to_sym => true
    else
      config.filter_run_excluding orm => true
    end
  end
end
