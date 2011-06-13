require 'spec_helper'

describe "RailsAdmin Basic Destroy" do

  describe "destroy" do
    before(:each) do
      @player = FactoryGirl.create :player
      get rails_admin_delete_path(:model_name => "player", :id => @player.id)
      click_button "Yes, I'm sure"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      response.should be_successful
    end

    it "should destroy an object" do
      @player.should be_nil
    end
  end

  describe "destroy" do
    before(:each) do
      @player = FactoryGirl.create :player
      get rails_admin_delete_path(:model_name => "player", :id => @player.id)
      click_button "Cancel"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      response.should be_successful
    end

    it "should not destroy an object" do
      @player.should be
    end
  end

  describe "destroy with missing object" do
    before(:each) do
      response = visit(rails_admin_destroy_path(:model_name => "player", :id => 1), :delete)
    end

    it "should raise NotFound" do
      response.status.should equal(404)
    end
  end

end
