require 'spec_helper'

describe 'RailsAdmin::UninstallGenerator' do
  include GeneratorSpec::TestCase
  include GeneratorHelpers

  tests RailsAdmin::UninstallGenerator
  destination ::File.expand_path("../tmp/dummy_app", __FILE__)

  before :all do
    prepare_destination
    FileUtils.cp_r(::File.expand_path("../../dummy_app/", __FILE__), ::File.expand_path('../', Pathname.new(destination_root))) # copying dummy_app to test directory
    FileUtils.rm(::File.expand_path("config/initializers/rails_admin.rb", Pathname.new(destination_root)))
    create_config_file('user')
    create_routes_file('user', 'admin')

    assert_file 'config/initializers/rails_admin.rb'
    assert has_route?("mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'")

    @output = run_generator
  end


  it "creates migrations for droping histories table" do
    assert_migration 'db/migrate/drop_rails_admin_histories_table.rb'
  end

  it "removes config file" do
    assert_no_file 'config/initializers/rails_admin.rb'
  end

  it "removes rails_admin route" do
    assert !has_route?("mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'")
  end
end
