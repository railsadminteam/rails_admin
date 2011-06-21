require 'spec_helper'

describe "RailsAdmin Basic Delete" do

  subject { page }

  describe "delete" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit rails_admin_delete_path(:model_name => "player", :id => @player.id)
    end

    it "should show \"Delete model\"" do
      should have_content("delete the player")
    end
  end

  describe "delete with missing object" do
    before(:each) do
      visit rails_admin_delete_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      page.driver.status_code.should eql(404)
    end
  end

  describe "delete with missing label" do
    it "should respond successfully" do
      @division = FactoryGirl.create :division
      @team = FactoryGirl.create :team, :name => "", :division => @division
      visit rails_admin_delete_path(:model_name => "division", :id => @division.id)
    end
  end
end
