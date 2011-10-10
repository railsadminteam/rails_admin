require 'spec_helper'
require 'generator_helpers'

describe 'RailsAdmin::InstallGenerator' do
  include GeneratorSpec::TestCase
  include GeneratorHelpers

  tests RailsAdmin::InstallGenerator
  destination ::File.expand_path("../tmp/dummy_app", __FILE__)

  before :all do
    @rails_root = Rails.configuration.root
    Rails.configuration.root = Pathname.new(destination_root)
  end

  after :all do
    Rails.configuration.root = @rails_root
  end

  context "when ran on a new app without Devise and RailsAdmin installed" do
    before :all do
      prepare_destination
      FileUtils.cp_r(::File.expand_path("../../dummy_app/", __FILE__), ::File.expand_path('../', Pathname.new(destination_root))) # copying dummy_app to test directory
      FileUtils.rm(::File.expand_path("config/initializers/rails_admin.rb", Pathname.new(destination_root)))
      FileUtils.rm(::File.expand_path("config/initializers/devise.rb", Pathname.new(destination_root)))
      create_routes_file(nil, nil)
      assert_no_migration 'db/migrate/create_rails_admin_histories_table.rb'
      assert_no_file 'config/initializers/rails_admin.rb'
      assert_no_file 'config/initializers/devise.rb'
      @output = run_generator ['admin', 'rails_admin_root']
    end

    it "creates a migration for rails_admin" do
      assert_migration 'db/migrate/create_rails_admin_histories_table.rb'
    end

    it "invokes devise setup" do
      assert @output.match /generate  devise/ # we don't want to test devise route and migration generation
    end

    it "creates an initializer" do
      assert_file 'config/initializers/rails_admin.rb'
    end

    it "generates a route for rails_admin" do
      assert has_route?("mount RailsAdmin::Engine => '/rails_admin_root', :as => 'rails_admin'")
    end

    it "adds a current_user_method with given Devise user name" do
      assert has_config?("current_admin")
    end
  end

  context "when upgrading an app with Devise and RailsAdmin already installed" do
    before :all do
      prepare_destination
      FileUtils.cp_r(::File.expand_path("../../dummy_app/", __FILE__), ::File.expand_path('../', Pathname.new(destination_root))) # copying dummy_app to test directory
      FileUtils.rm(::File.expand_path("config/initializers/rails_admin.rb", Pathname.new(destination_root)))
      create_routes_file('old_user', 'old_admin_route')
      create_config_file('old_user')
      assert has_config?('current_old_user')
      assert has_route?('devise_for :old_users')
      assert has_route?("mount RailsAdmin::Engine => '/old_admin_route', :as => 'rails_admin'")
      @output = run_generator ['new_user', 'new_admin_route']
    end

    it "should update RA route (only one instance of RailsAdmin allowed)" do
      assert has_route?("mount RailsAdmin::Engine => '/new_admin_route', :as => 'rails_admin'")
      assert !has_route?("mount RailsAdmin::Engine => '/old_admin_route', :as => 'rails_admin'")
    end

    it "invokes devise setup" do
      assert @output.match /generate  devise/
    end

    it "should create a new example config file" do
      assert ::File.exists?(::File.expand_path("config/initializers/rails_admin.rb.example", Pathname.new(destination_root)))
    end

    it "should update the config file with new user method" do
      assert has_config?('current_new_user')
      assert !has_config?('current_old_user')
    end
  end
end
