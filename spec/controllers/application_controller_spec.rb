require 'spec_helper'

describe RailsAdmin::ApplicationController do
  describe "#to_model_name" do
    it "handles classes nested in modules of the same name" do
      controller.to_model_name("conversations~conversations").should eq("Conversations::Conversation")
    end
  end
end