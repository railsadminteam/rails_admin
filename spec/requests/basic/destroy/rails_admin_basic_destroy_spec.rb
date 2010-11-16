require 'spec_helper'

describe "RailsAdmin Basic Destroy" do
  include Warden::Test::Helpers

  before(:each) do
    RailsAdmin::AbstractModel.new("Division").destroy_all!
    RailsAdmin::AbstractModel.new("Draft").destroy_all!
    RailsAdmin::AbstractModel.new("Fan").destroy_all!
    RailsAdmin::AbstractModel.new("League").destroy_all!
    RailsAdmin::AbstractModel.new("Player").destroy_all!
    RailsAdmin::AbstractModel.new("Team").destroy_all!
    RailsAdmin::AbstractModel.new("User").destroy_all!

    user = RailsAdmin::AbstractModel.new("User").create(
      :email => "test@test.com",
      :password => "test1234"
    )

    login_as user
  end

  after(:each) do
    Warden.test_reset!
  end

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

    it "should destroy an object" do
      @player.should_not be_nil
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

end
