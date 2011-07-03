require 'spec_helper'

describe "RailsAdmin Basic Create" do
  subject { page }

  describe "create" do
    before(:each) do
      visit rails_admin_new_path(:model_name => "player")

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      check "player[suspended]"
      click_button "Save"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
      @player.should be_suspended
    end
  end

  describe "create and edit" do
    before(:each) do
      visit rails_admin_new_path(:model_name => "player")

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      check "player[suspended]"
      click_button "Save and edit"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
      @player.should be_suspended
    end
  end

  describe "create and add another" do
    before(:each) do
      visit rails_admin_new_path(:model_name => "player")

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      check "player[suspended]"
      click_button "Save and add another"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
      @player.should be_suspended
    end
  end

  describe "create with has-one association" do
    before(:each) do
      @draft = FactoryGirl.create :draft

      visit rails_admin_new_path(:model_name => "player")

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => 42
      fill_in "player[position]", :with => "Second baseman"
      select "Draft ##{@draft.id}"

      click_button "Save"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should create an object with correct associations" do
      @draft.reload
      @player.draft.should eql(@draft)
    end
  end

  describe "create with has-many association" do
    before(:each) do
      @divisions = 3.times.map { FactoryGirl.create :division }

      visit rails_admin_new_path(:model_name => "league")

      fill_in "league[name]", :with => "National League"
      select @divisions[0].name, :from => "league_division_ids"

      click_button "Save"

      @league = RailsAdmin::AbstractModel.new("League").first
    end

    it "should create an object with correct associations" do
      @divisions[0].reload
      @league.divisions.should include(@divisions[0])
    end

    it "should not create an object with incorrect associations" do
      @league.divisions.should_not include(@divisions[1])
      @league.divisions.should_not include(@divisions[2])
    end
  end

  describe "create with has-and-belongs-to-many association" do
    before(:each) do
      @teams = 3.times.map { FactoryGirl.create :team }

      visit rails_admin_new_path(:model_name => "fan")

      fill_in "fan[name]", :with => "John Doe"
      select @teams[0].name, :from => "fan_team_ids"
      click_button "Save"

      @fan = RailsAdmin::AbstractModel.new("Fan").first
    end

    it "should create an object with correct associations" do
      @teams[0].reload
      @fan.teams.should include(@teams[0])
    end

    it "should not create an object with incorrect associations" do
      @fan.teams.should_not include(@teams[1])
      @fan.teams.should_not include(@teams[2])
    end
  end

  describe "create with uniqueness constraint violated", :given => "a player exists" do
    before(:each) do
      @team = FactoryGirl.create :team
      @player = FactoryGirl.create :player, :team => @team

      visit rails_admin_new_path(:model_name => "player")

      fill_in "player[name]", :with => @player.name
      fill_in "player[number]", :with => @player.number.to_s
      fill_in "player[position]", :with => @player.position
      select "#{@team.name}", :from => "player[team_id]"
      click_button "Save"
    end

    it "should show an error message" do
      should have_content("There is already a player with that number on this team")
    end
  end

  describe "create with invalid object" do
    before(:each) do
      page.driver.post(rails_admin_create_path(:model_name => "player", :id => 1), :params => {:player => {}})
    end

    it "should show an error message" do
      should have_content("Player failed to be created")
      should have_selector "form", :action => "/admin/players"
    end
  end

  describe "create with object with errors on base" do
    before(:each) do
      visit rails_admin_new_path(:model_name => "player")
      fill_in "player[name]", :with => "Jackie Robinson on steroids"
      click_button "Save and add another"
    end

    it "should show error base error message in flash" do
      should have_content("Player failed to be created. Player is cheating")
    end
  end
end
