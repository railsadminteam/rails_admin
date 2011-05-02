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
    @rails_root = Rails.configuration.root
    Rails.configuration.root = Pathname.new(destination_root)
  end
  
  after(:each) do
    Rails.configuration.root = @rails_root
  end

  context "when devise is installed" do
    before do
      create_devise_initializer
      create_routes_with_devise
      assert_no_file destination_root + "/config/locales/devise.en.yml"
      assert_no_file destination_root + "/config/locales/rails_admin.en.yml"
      silence_stream(STDOUT) { RailsAdmin::ExtraTasks.install }
    end

    it "creates locales files" do
      assert_file destination_root + "/config/locales/devise.en.yml"
      assert_file destination_root + "/config/locales/rails_admin.en.yml"
    end
  end
end
