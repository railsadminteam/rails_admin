require 'spec_helper'

describe 'RailsAdmin::InstallAdminGenerator' do
  context "with no arguments" do
    include GeneratorSpec::TestCase

    destination File.expand_path("../tmp", __FILE__)
    tests RailsAdmin::InstallAdminGenerator

    before(:each) do
      prepare_destination
      create_rails_folder_structure
    end

    context "when devise is installed" do
      before do
        create_devise_initializer
        create_routes_with_devise
        assert_no_file "config/locales/rails_admin.en.yml"
        run_generator
      end

      it "creates locales files" do
        assert_file "config/locales/devise.en.yml"
        assert_file "config/locales/rails_admin.en.yml"
      end
    end

    context "when devise is not installed" do
      before(:each) do
        create_routes_without_devise
        assert_no_file destination_root + "/config/initializers/devise.rb"
        run_generator
      end

      it "creates locales files" do
        assert_file destination_root + "/config/locales/rails_admin.en.yml"
      end

      it "installs devise" do
        assert_file destination_root + "/config/initializers/devise.rb"
      end
    end

  end
end
