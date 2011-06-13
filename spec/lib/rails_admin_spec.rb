require 'spec_helper'

describe RailsAdmin do
  describe ".add_extension" do
    it "registers the extension with RailsAdmin" do
      RailsAdmin.add_extension(:example, ExampleModule)
      RailsAdmin::EXTENSIONS.select { |name| name == :example }.length.should == 1
    end

    context "given an extension with an authorization adapter" do
      it "registers the adapter" do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :authorization => true
        })
        RailsAdmin::AUTHORIZATION_ADAPTERS[:example].should == ExampleModule::AuthorizationAdapter
      end
    end

    context "given an extension with a configuration adapter" do
      it "registers the adapter" do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :configuration => true
        })
        RailsAdmin::CONFIGURATION_ADAPTERS[:example].should == ExampleModule::ConfigurationAdapter
      end
    end
  end

  describe ".authorize_with" do
    after do
      RailsAdmin.authorize_with(nil) { @authorization_adapter = nil }
    end

    context "given a key for a extension with authorization" do
      before do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :authorization => true
        })
      end

      it "initializes the authorization adapter" do
        options = nil
        proc    = RailsAdmin.authorize_with(:example, options)

        ExampleModule::AuthorizationAdapter.should_receive(:new).with(RailsAdmin)
        proc.call
      end

      it "passes through any additional arguments to the initializer" do
        options = { :option => true }
        proc    = RailsAdmin.authorize_with(:example, options)

        ExampleModule::AuthorizationAdapter.should_receive(:new).with(RailsAdmin, options)
        proc.call
      end
    end
  end

  describe ".configure_with" do
    context "given a key for a extension with configuration" do
      before do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :configuration => true
        })
      end

      it "initializes configuration adapter" do
        ExampleModule::ConfigurationAdapter.should_receive(:new)
        RailsAdmin.configure_with(:example)
      end

      it "yields the (optionally) provided block, passing the initialized adapter" do
        configurator = nil

        RailsAdmin.configure_with(:example) do |config|
          configurator = config
        end
        configurator.should be_a(ExampleModule::ConfigurationAdapter)
      end
    end
  end
end

module ExampleModule
  class AuthorizationAdapter ; end
  class ConfigurationAdapter ; end
end
