require 'spec_helper'

describe RailsAdmin::ApplicationController do
  describe "#to_model_name" do
    it "works with modules" do
      controller.to_model_name("conversations~conversation").should eq("Conversations::Conversation")
    end
  end

  describe "helper method _get_plugin_name" do
    it "works by default" do
      controller.send(:_get_plugin_name).should == ['Dummy App', 'Admin']
    end

    it "works for static names" do
      RailsAdmin.config do |config|
        config.main_app_name = ['static','value']
      end
      controller.send(:_get_plugin_name).should == ['static', 'value']
    end

    it "works for dynamic names in the controller context" do
      RailsAdmin.config do |config|
        config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.try(:titleize), controller.params[:action].titleize] }
      end
      controller.params[:action] = "dashboard"
      controller.send(:_get_plugin_name).should == ["Dummy App Application", "Dashboard"]
    end
  end
end
