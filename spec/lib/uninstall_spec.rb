require 'spec_helper'

module Kernel
  def `(cmd); end
end

describe "rails_admin:uninstall Rake task" do
  include GeneratorSpec::TestCase
  destination ::File.expand_path("../tmp", __FILE__)

  before(:each) do
    prepare_destination
    create_rails_folder_structure
    @rails_root = Rails.configuration.root
    Rails.configuration.root = Pathname.new(destination_root)
  end

  after(:each) do
    Rails.configuration.root = @rails_root
  end

  context "initializer" do
    before(:each) do
      create_rails_admin_initializer
      assert_file destination_root + "/config/initializers/rails_admin.rb"
      silence_stream(STDOUT) { RailsAdmin::Tasks::Uninstall.run }
    end

    it "should be deleted" do
      assert_no_file destination_root + "/config/initializers/rails_admin.rb"
    end
  end

  context "locales" do
    before(:each) do
      FileUtils.touch ::File.join(destination_root, 'config', 'locales', 'rails_admin.en.yml')
      silence_stream(STDOUT) { RailsAdmin::Tasks::Uninstall.run }
    end

    it "should be deleted" do
      assert_no_file destination_root + "/config/locales/rails_admin.en.yml"
    end
  end

  context "Gemfile" do
    before(:each) do
      ::File.open(destination_root + '/Gemfile', 'w') do |f|
        f.puts "source 'http://rubygems.org'
          gem 'rails'
          gem 'devise' # Devise must be required before RailsAdmin
          gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
"
      end
      silence_stream(STDOUT) { RailsAdmin::Tasks::Uninstall.run }
    end

    it "should be updated" do

      actual = ::File.open(destination_root + '/Gemfile', 'r').read
      expected = "source 'http://rubygems.org'
          gem 'rails'
          gem 'devise' # Devise must be required before RailsAdmin
"
      assert_equal expected, actual
    end
  end

end
