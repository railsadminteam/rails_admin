require 'spec_helper'

module Kernel
  def `(cmd); end
end

describe "rails_admin:install Rake task" do
  include GeneratorSpec::TestCase
  destination File.expand_path("../tmp", __FILE__)

  before(:each) do
    prepare_destination
    create_rails_folder_structure
    Rails.configuration.root = Pathname.new(destination_root)
  end

  context "when devise is installed" do
    before do
      create_devise_initializer
      create_routes_with_devise
      assert_no_file destination_root + "/config/locales/devise.en.yml"
      assert_no_file destination_root + "/config/locales/rails_admin.en.yml"
      RailsAdmin::ExtraTasks.install
    end

    it "creates locales files" do
      assert_file destination_root + "/config/locales/devise.en.yml"
      assert_file destination_root + "/config/locales/rails_admin.en.yml"
    end
  end
end
