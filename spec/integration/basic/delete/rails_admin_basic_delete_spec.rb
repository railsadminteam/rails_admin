require 'spec_helper'

describe "RailsAdmin Basic Delete" do

  subject { page }

  describe "delete" do
    it "should show \"Delete model\"" do
      @draft = FactoryGirl.create :draft
      @player = @draft.player
      @comment = @player.comments.create
      visit delete_path(:model_name => "player", :id => @player.id)
      should have_content("delete this player")
      should have_link(@player.name, :href => "/admin/player/#{@player.id}")
      should have_link("Draft ##{@draft.id}", :href => "/admin/draft/#{@draft.id}")
      should have_link("Comment ##{@comment.id}", :href => "/admin/comment/#{@comment.id}")
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

  describe "with show action disabled" do
    before(:each) do
      RailsAdmin.config.actions do
        dashboard
        index
        delete
      end
      @draft = FactoryGirl.create :draft
      @player = @draft.player
      @comment = @player.comments.create
      visit delete_path(:model_name => "player", :id => @player.id)
    end

    it "should show \"Delete model\"" do
      should have_content("delete this player")
      should_not have_selector("a[href=\"/admin/player/#{@player.id}\"]")
      should_not have_selector("a[href=\"/admin/draft/#{@draft.id}\"]")
      should_not have_selector("a[href=\"/admin/comment/#{@comment.id}\"]")
    end
  end

  describe "delete of an object which has an associated item without id" do
    before(:each) do
      @player = FactoryGirl.create :player
      Player.any_instance.stub(:draft).and_return(Draft.new)
      visit delete_path(:model_name => "player", :id => @player.id)
    end

    it "should show \"Delete model\"" do
      should_not have_content("Routing Error")
      should have_content("delete this player")
      should have_link(@player.name, :href => "/admin/player/#{@player.id}")
    end
  end
end
