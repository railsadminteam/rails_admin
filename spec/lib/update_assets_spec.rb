require 'spec_helper'

describe "rails_admin:update_assets Rake task" do
  include GeneratorSpec::TestCase
  destination File.expand_path('../tmp', __FILE__)

  before(:each) do
    prepare_rake_task_environment
    @gem_root = File.expand_path('../../..', __FILE__)
    stub($stdin).gets { 'yes' }
  end

  context "when assets wasn't previously installed" do
    before do
      assert_no_directory "#{destination_root}/public/javascripts/rails_admin"
      assert_no_directory "#{destination_root}/public/stylesheets/rails_admin"
      assert_no_directory "#{destination_root}/public/images/rails_admin"
      silence_stream(STDOUT) { RailsAdmin::Tasks::UpdateAssets.new.run }
    end

    it "creates assets files" do
      assert_file "#{destination_root}/public/javascripts/rails_admin/application.js"
      assert_directory "#{destination_root}/public/stylesheets/rails_admin"
      assert_directory "#{destination_root}/public/images/rails_admin"
    end
  end

  context "when assets was previously installed" do
    before do
      @relative_path = '/public/javascripts/rails_admin/application.js'
      @orphaned_file = "#{destination_root}/public/javascripts/rails_admin/dummy.css"
      @orphaned_dir  = "#{destination_root}/public/javascripts/rails_admin/dummy_folder"

      FileUtils.mkdir_p File.dirname(destination_root + @relative_path)
      FileUtils.touch destination_root + @relative_path
      FileUtils.mkdir_p @orphaned_dir
      FileUtils.touch @orphaned_file
      silence_stream(STDOUT) { RailsAdmin::Tasks::UpdateAssets.new.run }
    end

    it "updates assets" do
      assert_equal File.read(@gem_root + @relative_path), File.read(destination_root + @relative_path)
    end

    it "deletes orphaned files and folders" do
      assert_no_directory @orphaned_dir
      assert_no_file @orphaned_file
    end
  end
end
