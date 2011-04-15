require 'spec_helper'

describe RailsAdmin do
  describe ".clear_modules" do
    before do
      RailsAdmin::MODULES << :example
      RailsAdmin::AUTHORIZATION_ADAPTERS[:example] = Object
    end

    it "removes all modules and respective adapters" do
      RailsAdmin.clear_modules
      RailsAdmin::MODULES.should be_empty
      RailsAdmin::AUTHORIZATION_ADAPTERS.should be_empty
    end
  end

  describe ".add_module" do
    it "registers the module with RailsAdmin" do
      RailsAdmin.add_module(:example, ExampleModule)
      RailsAdmin::MODULES.select { |name| name == :example }.length.should == 1
    end

    context "given a module with an authorization adapter" do
      it "registers the adapter" do
        RailsAdmin.add_module(:example, ExampleModule, {
          :authorization => true
        })
        RailsAdmin::AUTHORIZATION_ADAPTERS[:example].should == ExampleModule::AuthorizationAdapter
      end
    end
  end

  describe ".authorize_with" do
    context "given a key for a module with authorization" do
      let(:proc) { RailsAdmin.authorize_with(:example) }

      before do
        RailsAdmin.add_module(:example, ExampleModule, {
          :authorization => true
        })
      end

      it "initializes the authorization adapter" do
        mock(ExampleModule::AuthorizationAdapter).new(RailsAdmin)
        proc.call
      end
    end
  end
end

module ExampleModule
  class AuthorizationAdapter ; end
end
