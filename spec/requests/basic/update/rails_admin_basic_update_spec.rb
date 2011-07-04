require 'spec_helper'

describe "RailsAdmin Basic Update" do

  subject { page }

  describe "update with errors" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit rails_admin_edit_path(:model_name => "player", :id => @player.id)
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

      visit rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      check "player[suspended]"
      click_button "Save"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
      @player.should be_suspended
    end
  end

  describe "update and edit" do
    before(:each) do
      @player = FactoryGirl.create :player

      visit rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      check "player[suspended]"
      click_button "Save and edit"

      @player.reload
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
      @player.should be_suspended
    end
  end

  describe "update with has-one association" do
    before(:each) do
      @player = FactoryGirl.create :player
      @draft = FactoryGirl.create :draft

      visit rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      select "Draft ##{@draft.id}"
      click_button "Save"

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

  describe "update with has-many association", :given => ["a league exists", "three teams exist"] do
    before(:each) do
      @league = FactoryGirl.create :league
      @divisions = 3.times.map { FactoryGirl.create :division }

      visit rails_admin_edit_path(:model_name => "league", :id => @league.id)

      fill_in "league[name]", :with => "National League"
      select @divisions[0].name, :from => "league_division_ids"
      click_button "Save"

      @league.reload
      @histories = RailsAdmin::History.where(:item => @league.id)
    end

    it "should update an object with correct attributes" do
      @league.name.should eql("National League")
    end

    it "should update an object with correct associations" do
      @divisions[0].reload
      @league.divisions.should include(@divisions[0])
    end

    it "should not update an object with incorrect associations" do
      @league.divisions.should_not include(@divisions[1])
      @league.divisions.should_not include(@divisions[2])
    end

    it "should log a history message about the update" do
      @histories.collect(&:message).should include("Added Divisions ##{@divisions[0].id} associations, Changed name")
    end

    describe "removing has-many associations" do
      before(:each) do
        visit rails_admin_edit_path(:model_name => "league", :id => @league.id)

        unselect @divisions[0].name, :from => "league_division_ids"
        click_button "Save"

        @league.reload
        @histories.reload
      end

      it "should have empty associations" do
        @league.divisions.should be_empty
      end

      it "should log a message to history about removing associations" do
        @histories.collect(&:message).should include("Removed Divisions ##{@divisions[0].id} associations")
      end
    end
  end

  describe "update with has-and-belongs-to-many association" do
    before(:each) do
      @teams = 3.times.map { FactoryGirl.create :team }
      @fan = FactoryGirl.create :fan, :teams => [@teams[0]]

      visit rails_admin_edit_path(:model_name => "fan", :id => @fan.id)

      select @teams[1].name, :from => "fan_team_ids"
      click_button "Save"

      @fan.reload
    end

    it "should update an object with correct associations" do
      @fan.teams.should include(@teams[0])
      @fan.teams.should include(@teams[1])
    end

    it "should not update an object with incorrect associations" do
      @fan.teams.should_not include(@teams[2])
    end
  end

  describe "update with missing object" do
    before(:each) do
      page.driver.put(rails_admin_update_path(:model_name => "player", :id => 1), :params => {:player => {:name => "Jackie Robinson", :number => 42, :position => "Second baseman"}})
    end

    it "should raise NotFound" do
      page.driver.status_code.should eql(404)
    end
  end

  describe "update with invalid object" do
    before(:each) do
      @player = FactoryGirl.create :player

      visit rails_admin_edit_path(:model_name => "player", :id => @player.id)

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

      visit rails_admin_edit_path(:model_name => "user", :id => @user.id)

      fill_in "user[roles]", :with => "[\"admin\", \"user\"]"
      click_button "Save"

      @user.reload
    end

    it "should save the serialized data" do
      @user.roles.should eql(['admin','user'])
    end
  end

end
