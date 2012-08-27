require 'spec_helper'

# forces a read of text which is translated by globalize3,
# which creates empty translations
def custom_player_label
  "#{self.name} - #{self.text}"
end

describe "RailsAdmin Basic Delete" do

  subject { page }

  describe "delete" do
    before(:each) do
      @draft = FactoryGirl.create :draft
      @player = @draft.player
      @comment = @player.comments.create
      visit delete_path(:model_name => "player", :id => @player.id)
    end

    it "should show \"Delete model\"" do
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

  describe "with globalize3 empty translation associations" do
    before(:each) do
      RailsAdmin.config.actions do
        dashboard
        index
        delete
	show
      end
      RailsAdmin.config do |c|
        c.model Player do
          object_label_method do
            :custom_player_label
          end
        end
      end
      @draft = FactoryGirl.create :draft
      @player = @draft.player
      visit delete_path(:model_name => "player", :id => @player.id)
      save_and_open_page
    end

    it "should show \"Delete model\"" do
      should have_content("delete this player")
      should have_content("new Player::Translation")
    end
  end
end
