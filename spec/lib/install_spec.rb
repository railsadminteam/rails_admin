require 'spec_helper'

module Kernel
  def `(cmd); end
end

describe "Rake tasks" do
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

  describe "rails_admin:copy_locales" do
    before do
      assert_no_file destination_root + "/config/locales/devise.en.yml"
      assert_no_file destination_root + "/config/locales/rails_admin.en.yml"
      silence_stream(STDOUT) { RailsAdmin::Tasks::Install.copy_locales_files }
    end

    it "creates locales files" do
      assert_file destination_root + "/config/locales/devise.en.yml"
      assert_file destination_root + "/config/locales/rails_admin.en.yml"
    end
  end

  describe "rails_admin:copy_views" do
    before do
      assert_no_directory destination_root + "/app/views/layouts/rails_admin"
      assert_no_directory destination_root + "/app/views/rails_admin"
      silence_stream(STDOUT) { RailsAdmin::Tasks::Install.copy_view_files }
    end

    it "creates rails_admin layout files" do
      assert_directory destination_root + "/app/views/layouts/rails_admin"
    end

    it "creates rails_admin controller view files" do
      assert_directory destination_root + "/app/views/rails_admin"
      assert_directory destination_root + "/app/views/rails_admin/history"
      assert_directory destination_root + "/app/views/rails_admin/main"
    end
  end

end

