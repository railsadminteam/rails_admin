require 'spec_helper'

describe "RailsAdmin Basic Destroy" do

  subject { page }

  describe "destroy" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit delete_path(:model_name => "player", :id => @player.id)
      click_button "Yes, I'm sure"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should destroy an object" do
      @player.should be_nil
    end
  end

  describe "destroy with errors" do
    before(:each) do
      Player.any_instance.stub(:destroy).and_return false
      @player = FactoryGirl.create :player
      visit delete_path(:model_name => "player", :id => @player.id)
      click_button "Yes, I'm sure"
    end

    it "should destroy an object" do
      @player.reload.should be
    end
  end

  describe "destroy" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit delete_path(:model_name => "player", :id => @player.id)
      click_button "Cancel"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should not destroy an object" do
      @player.should be
    end
  end

  describe "destroy with missing object" do
    before(:each) do
      page.driver.delete(destroy_path(:model_name => "player", :id => 1))
    end

    it "should raise NotFound" do
      page.driver.status_code.should eql(404)
    end
  end

end
