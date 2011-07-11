require 'spec_helper'

describe "RailsAdmin Basic Show" do

  describe "show" do
    before(:each) do
      @player = Factory.create :player
      get rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should load @abstract_model, @object" do
      assigns(:abstract_model).should be
      assigns(:object).should be
    end

    it "should have History, Edit, Delete, Cancel buttons" do
      response.body.should have_selector("a.button", :text => "History")
      response.body.should have_selector("a.button", :text => "Edit")
      response.body.should have_selector("a.button", :text => "Delete")
    end

    it "should show 'Details'" do
      response.body.should have_content("Details")
    end

    it "should show attributes" do
      response.body.should have_content("Name")
      response.body.should have_content(@player.name)
      response.body.should have_content("Number")
      response.body.should have_content(@player.number)
    end
  end

  describe "show with belongs_to association" do
    before(:each) do
      @player = Factory.create :player
      @team   = Factory.create :team
      @player.update_attribute(:team, @team)
      get rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should have_selector("div.value", :text => "Team ##{@team.id}")
    end
  end

  describe "show with has-one association" do
    before(:each) do
      @player = Factory.create :player
      @draft  = Factory.create :draft, :player => @player
      get rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should have_selector("div.value", :text => "Draft ##{@draft.id}")
    end
  end

  describe "show with has-and-belongs-to-many association" do
    before(:each) do
      @player = Factory.create :player
      @comment1 = Factory.create :comment, :commentable => @player
      @comment2 = Factory.create :comment, :commentable => @player
      @comment3 = Factory.create :comment, :commentable => Factory.create(:player)

      get rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should have_selector("div.value", :text => "Comment ##{@comment1.id}")
      response.body.should have_selector("div.value", :text => "Comment ##{@comment2.id}")
      response.body.should_not have_selector("div.value", :text => "Comment ##{@comment3.id}")
    end
  end

  describe "show with missing object" do
    before(:each) do
      get rails_admin_show_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      response.status.should equal(404)
    end
  end

  describe "show for polymorphic objects" do
    before(:each) do
      @player = Factory.create :player
      @comment = Factory.create :comment, :commentable => @player
      get rails_admin_show_path(:model_name => "comment", :id => @comment.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated object" do
      response.body.should have_selector("div.value", :text => "Player ##{@player.id}")
    end
  end
end
