require 'spec_helper'

describe "RailsAdmin Basic Show" do
  subject { page }

  describe "show" do
    before(:each) do
      @player = Factory.create :player
      visit rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should have History, Edit, Delete, Cancel buttons" do
      should have_selector("a.button", :text => "History")
      should have_selector("a.button", :text => "Edit")
      should have_selector("a.button", :text => "Delete")
    end

    it "should show 'Details'" do
      should have_content("Details")
    end

    it "should show attributes" do
      should have_content("Name")
      should have_content(@player.name)
      should have_content("Number")
      should have_content(@player.number)
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
      should have_css("a[href='/admin/teams/#{@team.id}']")
    end
  end

  describe "show with has-one association" do
    before(:each) do
      @player = Factory.create :player
      @draft  = Factory.create :draft, :player => @player
      visit rails_admin_show_path(:model_name => "player", :id => @player.id)
    end

    it "should show associated objects" do
      should have_css("a[href='/admin/drafts/#{@draft.id}']")
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
      should have_css("a[href='/admin/comments/#{@comment1.id}']")
      should have_css("a[href='/admin/comments/#{@comment2.id}']")
      should_not have_css("a[href='/admin/comments/#{@comment3.id}']")
    end
  end

  describe "show for polymorphic objects" do
    before(:each) do
      @player = Factory.create :player
      @comment = Factory.create :comment, :commentable => @player
      visit rails_admin_show_path(:model_name => "comment", :id => @comment.id)
    end

    it "should show associated object" do
      should have_css("a[href='/admin/players/#{@player.id}']")
    end
  end
end
