require 'spec_helper'

describe 'RailsAdmin::UninstallMigrationsGenerator' do
  context "with no arguments" do
    include GeneratorSpec::TestCase

    destination File.expand_path("../tmp", __FILE__)
    tests RailsAdmin::UninstallMigrationsGenerator

    before(:each) do
      prepare_destination
      assert_no_migration 'db/migrate/drop_rails_admin_histories.rb'
      run_generator
    end

    it "creates migrations" do
      assert_migration 'db/migrate/drop_rails_admin_histories.rb'
    end
  end
end
