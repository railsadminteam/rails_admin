require 'spec_helper'

describe "rails_admin:uninstall Rake task" do
  include GeneratorSpec::TestCase
  destination ::File.expand_path("../tmp", __FILE__)

  before(:each) { prepare_rake_task_environment }

  context "initializer" do
    before(:each) do
      create_rails_admin_initializer
      assert_file "#{destination_root}/config/initializers/rails_admin.rb"
      silence_stream(STDOUT) { RailsAdmin::Tasks::Uninstall.new.invoke_all }
    end

    it "should be deleted" do
      assert_no_file "#{destination_root}/config/initializers/rails_admin.rb"
    end
  end

  context "locales" do
    before(:each) do
      FileUtils.touch ::File.join(destination_root, 'config', 'locales', 'rails_admin.en.yml')
      silence_stream(STDOUT) { RailsAdmin::Tasks::Uninstall.new.invoke_all }
    end

    it "should be deleted" do
      assert_no_file "#{destination_root}/config/locales/rails_admin.en.yml"
    end
  end

  context "Gemfile" do
    before(:each) do
      ::File.open(destination_root + '/Gemfile', 'w') do |f|
        f.puts <<-GEMFILE
          source 'http://rubygems.org'
          gem 'rails'
          gem 'devise' # Devise must be required before RailsAdmin
          gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'
        GEMFILE
      end
      silence_stream(STDOUT) { RailsAdmin::Tasks::Uninstall.new.invoke_all }
    end

    it "should be updated" do

      actual = ::File.open("#{destination_root}/Gemfile", 'r').read
      expected = <<-GEMFILE
          source 'http://rubygems.org'
          gem 'rails'
          gem 'devise' # Devise must be required before RailsAdmin
      GEMFILE

      assert_equal expected, actual
    end
  end

end
