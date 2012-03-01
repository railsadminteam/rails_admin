require 'spec_helper'

describe "RailsAdmin Basic Delete" do

  subject { page }

  describe "delete" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit delete_path(:model_name => "player", :id => @player.id)
    end

    it "should show \"Delete model\"" do
      should have_content("delete this player")
    end
  end

  describe "delete with missing object" do
    before(:each) do
      visit delete_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      page.driver.status_code.should eql(404)
    end
  end
end
