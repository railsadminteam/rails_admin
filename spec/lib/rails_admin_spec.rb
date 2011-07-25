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
    context "given a key for a extension with authorization" do
      before do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :authorization => true
        })
      end

      it "initializes the authorization adapter" do
        ExampleModule::AuthorizationAdapter.should_receive(:new).with(RailsAdmin::Config)
        RailsAdmin.config do |config|
          config.authorize_with(:example)
        end
        RailsAdmin.config.authorize_with.call
      end

      it "passes through any additional arguments to the initializer" do
        options = { :option => true }
        ExampleModule::AuthorizationAdapter.should_receive(:new).with(RailsAdmin::Config, options)
        RailsAdmin.config do |config|
          config.authorize_with(:example, options)
        end
        RailsAdmin.config.authorize_with.call
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
        RailsAdmin.config do |config|
          config.configure_with(:example)
        end
      end

      it "yields the (optionally) provided block, passing the initialized adapter" do
        configurator = nil
        RailsAdmin.config do |config|
          config.configure_with(:example) do |configuration_adapter|
            configurator = configuration_adapter
          end
        end
        configurator.should be_a(ExampleModule::ConfigurationAdapter)
      end
    end
  end

  describe ".config" do
    context ".default_search_operator" do
      it "sets the default_search_operator" do
        RailsAdmin.config do |config|
          config.default_search_operator = 'starts_with'
        end
        RailsAdmin::Config.default_search_operator.should == 'starts_with'
      end

      it "errors on unrecognized search operator" do
        expect do
          RailsAdmin.config do |config|
            config.default_search_operator = 'random'
          end
        end.to raise_error(ArgumentError, "Search operator 'random' not supported")
      end

      it "defaults to 'default'" do
        RailsAdmin::Config.default_search_operator.should == 'default'
      end
    end
  end
end

module ExampleModule
  class AuthorizationAdapter ; end
  class ConfigurationAdapter ; end
end
