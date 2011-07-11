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

require 'rails/test_help'
require 'generator_spec/test_case'
require 'generators/rails_admin/install_migrations_generator'
require File.dirname(__FILE__) + '/../lib/rails_admin/tasks/install'
require File.dirname(__FILE__) + '/../lib/rails_admin/tasks/uninstall'
require 'generators/rails_admin/uninstall_migrations_generator'
require 'generators/rails_admin/rails_admin_generator'
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

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each{|f| require f}

RSpec.configure do |config|
  require 'rspec/expectations'

  config.include RSpec::Matchers
  config.include DatabaseHelpers
  config.include GeneratorHelpers

  config.include Warden::Test::Helpers

  config.before(:each) do
    RailsAdmin.setup
    RailsAdmin::Config.excluded_models = [RelTest, FieldTest]
    RailsAdmin::AbstractModel.instance_variable_get("@models").clear

    RailsAdmin::AbstractModel.new("Division").destroy_all!
    RailsAdmin::AbstractModel.new("Draft").destroy_all!
    RailsAdmin::AbstractModel.new("Fan").destroy_all!
    RailsAdmin::AbstractModel.new("League").destroy_all!
    RailsAdmin::AbstractModel.new("Player").destroy_all!
    RailsAdmin::AbstractModel.new("Team").destroy_all!
    RailsAdmin::AbstractModel.new("User").destroy_all!

    user = RailsAdmin::AbstractModel.new("User").create(
      :email => "username@example.com",
      :password => "password"
    )

    login_as user
  end

  config.after(:each) do
    RailsAdmin.test_reset!
    Warden.test_reset!
  end
end
