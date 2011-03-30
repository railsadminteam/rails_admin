require 'spec_helper'

describe "RailsAdmin Basic Delete" do

  describe "delete" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
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
      @response.status.should equal(404)
    end
  end

  describe "delete with missing label" do
    before(:each) do
      @league = RailsAdmin::AbstractModel.new("League").create(:name => "League 1")
      @team = RailsAdmin::AbstractModel.new("Division").create(:league_id => @league.id, :name => "Division 1")

      get rails_admin_delete_path(:model_name => "league", :id => @league.id)
    end

    it "should respond successfully" do
      @response.should be_successful
    end
  end
end
