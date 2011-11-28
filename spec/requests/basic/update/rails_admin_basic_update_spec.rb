require 'spec_helper'

describe "RailsAdmin Basic Update" do

  subject { page }

  describe "update with errors" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit edit_path(:model_name => "player", :id => @player.id)
    end

    it "should return to edit page" do
      fill_in "player[name]", :with => ""
      click_button "Save"
      page.driver.status_code.should eql(406)
      should have_selector "form", :action => "/admin/players/#{@player.id}"
    end
  end

  describe "update and add another" do
    before(:each) do
      @player = FactoryGirl.create :player

      visit edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "update and edit" do
    before(:each) do
      @player = FactoryGirl.create :player

      visit edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save and edit"

      @player.reload
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "update with has-one association" do
    before(:each) do
      @player = FactoryGirl.create :player
      @draft = FactoryGirl.create :draft
      page.driver.put update_path(:model_name => "player", :id => @player.id, :player => {:name => "Jackie Robinson", :draft_id => @draft.id, :number => 42, :position => "Second baseman"})
      @player.reload
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end

    it "should update an object with correct associations" do
      @draft.reload
      @player.draft.should eql(@draft)
    end
  end

  describe "update with has-many association" do
    it "should be fillable and emptyable" do
      @league = FactoryGirl.create :league
      @divisions = 3.times.map { Division.create!(:name => "div #{Time.now.to_f}", :league => League.create!(:name => "league #{Time.now.to_f}")) }

      page.driver.put update_path(:model_name => "league", :id => @league.id, :league => {:name => "National League", :division_ids => [@divisions[0].id] })

      @league.reload
      @league.name.should eql("National League")
      @divisions[0].reload
      @league.divisions.should include(@divisions[0])
      @league.divisions.should_not include(@divisions[1])
      @league.divisions.should_not include(@divisions[2])
      RailsAdmin::History.where(:item => @league.id).collect(&:message).should include("Added Divisions ##{@divisions[0].id} associations, Changed name")

      page.driver.put update_path(:model_name => "league", :id => @league.id, :league => {:division_ids => [""]})

      @league.reload
      @league.divisions.should be_empty
      RailsAdmin::History.where(:item => @league.id).collect(&:message).should include("Removed Divisions ##{@divisions[0].id} associations")
    end
  end

  describe "update with missing object" do
    before(:each) do
      page.driver.put(update_path(:model_name => "player", :id => 1), :params => {:player => {:name => "Jackie Robinson", :number => 42, :position => "Second baseman"}})
    end

    it "should raise NotFound" do
      page.driver.status_code.should eql(404)
    end
  end

  describe "update with invalid object" do
    before(:each) do
      @player = FactoryGirl.create :player

      visit edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "a"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save"

      @player.reload
    end

    it "should show an error message" do
      body.should have_content("Player failed to be updated")
    end
  end

  describe "update with serialized objects" do
    before(:each) do
      @user = FactoryGirl.create :user

      visit edit_path(:model_name => "user", :id => @user.id)

      fill_in "user[roles]", :with => %{['admin', 'user']}
      click_button "Save"

      @user.reload
    end

    it "should save the serialized data" do
      @user.roles.should eql(['admin','user'])
    end
  end

  describe "update with overridden to_param" do
    before(:each) do
      @ball = FactoryGirl.create :ball

      visit edit_path(:model_name => "ball", :id => @ball.id)

      fill_in "ball[color]", :with => "gray"
      click_button "Save and edit"

      @ball.reload
    end

    it "should update an object with correct attributes" do
      @ball.color.should eql("gray")
    end
  end

  describe "update of STI subclass on superclass view" do
    before(:each) do
      @hardball = FactoryGirl.create :hardball

      visit edit_path(:model_name => "ball", :id => @hardball.id)

      fill_in "ball[color]", :with => "cyan"
      click_button "Save and edit"

      @hardball.reload
    end

    it "should update an object with correct attributes" do
      @hardball.color.should eql("cyan")
    end
  end

end
