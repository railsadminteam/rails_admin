require 'spec_helper'

describe "RailsAdmin Basic Destroy" do

  describe "destroy" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")

      get rails_admin_delete_path(:model_name => "player", :id => @player.id)

      @req = click_button "Yes, I'm sure"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should destroy an object" do
      @player.should be_nil
    end
  end

  describe "destroy" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")

      get rails_admin_delete_path(:model_name => "player", :id => @player.id)

      @req = click_button "Cancel"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should not destroy an object" do
      @player.should be
    end
  end

  describe "destroy with missing object" do
    before(:each) do
      @req = visit(rails_admin_destroy_path(:model_name => "player", :id => 1), :delete)
    end

    it "should raise NotFound" do
      @req.status.should equal(404)
    end
  end

  describe "soft_destroy" do
    before(:each) do
      @coach = RailsAdmin::AbstractModel.new("Coach").create(:name => "Coach 1")

      get rails_admin_delete_path(:model_name => "coach", :id => @coach.id)

      @req = click_button "Yes, I'm sure"
      @coach = RailsAdmin::AbstractModel.new("Coach").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should disable an object" do
      @coach.disabled.should eql(true)
    end
  end

  describe "soft_destroy_with_custom_method" do
    before(:each) do
      @club = RailsAdmin::AbstractModel.new("Club").create(:name => "Club 1")

      get rails_admin_delete_path(:model_name => "club", :id => @club.id)

      @req = click_button "Yes, I'm sure"
      @club = RailsAdmin::AbstractModel.new("Club").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should disable an object" do
      @club.disabled.should eql(true)
    end
  end
end
