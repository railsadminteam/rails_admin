require 'spec_helper'

describe RailsAdmin::ApplicationController do
  describe "#to_model_name" do
    it "handles classes nested in modules of the same name" do
      controller.to_model_name("conversations~conversations").should eq("Conversations::Conversations")
    end

    it "should convert with singularity" do
      controller.to_model_name_with_singularize("conversations~conversations").should eq("Conversations::Conversation")
    end

    it "should convert without singularity" do
      controller.to_model_name_without_singularize("conversations~conversations").should eq("Conversations::Conversations")
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
