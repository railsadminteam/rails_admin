require 'spec_helper'

describe 'RailsAdmin::InstallMigrationsGenerator' do
  context "with no arguments" do
    include GeneratorSpec::TestCase

    destination File.expand_path("../tmp", __FILE__)
    tests RailsAdmin::InstallMigrationsGenerator

    before(:each) do
      prepare_destination
      assert_no_migration 'db/migrate/create_rails_admin_histories_table.rb'
      run_generator
    end

    it "creates migrations" do
      assert_migration 'db/migrate/create_rails_admin_histories_table.rb'
    end

  end
end
