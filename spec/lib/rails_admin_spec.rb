require 'spec_helper'

describe RailsAdmin do
  describe ".add_extension" do
    it "registers the extension with RailsAdmin" do
      RailsAdmin.add_extension(:example, ExampleModule)
      RailsAdmin::EXTENSIONS.select { |name| name == :example }.length.should == 1
    end

    context "given a extension with an authorization adapter" do
      it "registers the adapter" do
        RailsAdmin.add_extension(:example, ExampleModule, {
          :authorization => true
        })
        RailsAdmin::AUTHORIZATION_ADAPTERS[:example].should == ExampleModule::AuthorizationAdapter
      end
    end
  end

  describe ".authorize_with" do
    after do
      RailsAdmin.authorize_with(nil) { @authorization_adapter = nil }
    end

    context "given a key for a extension with authorization" do
      let(:proc) { RailsAdmin.authorize_with(:example) }

      before do
        RailsAdmin.add_extension(:example, ExampleModule, {
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
