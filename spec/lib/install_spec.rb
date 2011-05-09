require 'spec_helper'

describe "rails_admin:install Rake task" do
  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __FILE__)

  before(:each) { prepare_rake_task_environment }

  context "when devise is installed" do
    before do
      create_devise_initializer
      create_routes_with_devise
      assert_no_file "#{destination_root}/config/locales/devise.en.yml"
      assert_no_file "#{destination_root}/config/locales/rails_admin.en.yml"

      assert_no_file "#{destination_root}/public/javascripts/rails_admin/application.js"
      assert_no_directory "#{destination_root}/public/stylesheets/rails_admin"
      assert_no_directory "#{destination_root}/public/images/rails_admin"
      silence_stream(STDOUT) { RailsAdmin::Tasks::Install.run }
    end

    it "creates locales files" do
      assert_file "#{destination_root}/config/locales/devise.en.yml"
      assert_file "#{destination_root}/config/locales/rails_admin.en.yml"
    end

    it "creates rails_admin assets" do
      assert_file "#{destination_root}/public/javascripts/rails_admin/application.js"
      assert_directory "#{destination_root}/public/stylesheets/rails_admin"
      assert_directory "#{destination_root}/public/images/rails_admin"
    end
  end

end
