require 'spec_helper'

describe "RailsAdmin Basic Delete" do

  describe "delete" do
    before(:each) do
      @player = Factory.create :player
      get rails_admin_delete_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show \"Delete model\"" do
      response.body.should contain("Delete player")
    end
  end

  describe "delete with missing object" do
    before(:each) do
      get rails_admin_delete_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      response.status.should equal(404)
    end
  end

  describe "delete with missing label" do
    before(:each) do
      @division = Factory.create :division
      @team = Factory.create :team, :name => "", :division => @division
      get rails_admin_delete_path(:model_name => "division", :id => @division.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end
  end
end
