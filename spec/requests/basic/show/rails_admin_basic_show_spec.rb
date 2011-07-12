require 'spec_helper'

describe "RailsAdmin Basic Show" do

  describe "show" do
    before(:each) do
      @player = Factory.create :player
      visit rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should have History, Edit, Delete, Cancel buttons" do
      page.should have_selector("a.button", :text => "History")
      page.should have_selector("a.button", :text => "Edit")
      page.should have_selector("a.button", :text => "Delete")
    end

    it "should show 'Details'" do
      page.should have_content("Details")
    end

    it "should show attributes" do
      page.should have_content("Name")
      page.should have_content(@player.name)
      page.should have_content("Number")
      page.should have_content(@player.number)
    end
  end

  describe "show with belongs_to association" do
    before(:each) do
      @player = Factory.create :player
      @team   = Factory.create :team
      @player.update_attribute(:team, @team)
      visit rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should show associated objects" do
      page.should have_selector("div.value", :text => "Team ##{@team.id}")
    end
  end

  describe "show with has-one association" do
    before(:each) do
      @player = Factory.create :player
      @draft  = Factory.create :draft, :player => @player
      visit rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should show associated objects" do
      page.should have_selector("div.value", :text => "Draft ##{@draft.id}")
    end
  end

  describe "show with has-and-belongs-to-many association" do
    before(:each) do
      @player = Factory.create :player
      @comment1 = Factory.create :comment, :commentable => @player
      @comment2 = Factory.create :comment, :commentable => @player
      @comment3 = Factory.create :comment, :commentable => Factory.create(:player)

      visit rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should show associated objects" do
      page.should have_selector("div.value", :text => "Comment ##{@comment1.id}")
      page.should have_selector("div.value", :text => "Comment ##{@comment2.id}")
      page.should_not have_selector("div.value", :text => "Comment ##{@comment3.id}")
    end
  end

  describe "show for polymorphic objects" do
    before(:each) do
      @player = Factory.create :player
      @comment = Factory.create :comment, :commentable => @player
      visit rails_admin_show_path(:model_name => "comment", :id => @comment.id)
    end

    it "should show associated object" do
      page.should have_selector("div.value", :text => "Player ##{@player.id}")
    end
  end
end
