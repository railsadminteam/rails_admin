require 'spec_helper'

describe "RailsAdmin Basic Create" do
  subject { page }

  describe "create" do
    before(:each) do
      visit new_path(:model_name => "player")

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "create and edit" do
    before(:each) do
      visit new_path(:model_name => "player")

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save and edit"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "create and add another" do
    before(:each) do
      visit new_path(:model_name => "player")

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save and add another"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "create with has-one association" do
    before(:each) do
      @draft = FactoryGirl.create :draft

      page.driver.post create_path(:model_name => "player", :player => {:name => "Jackie Robinson", :number => 42, :position => 'Second baseman', :draft_id => @draft.id})

      @player = RailsAdmin::AbstractModel.new("Player").all.last # first is created by FactoryGirl
    end

    it "should create an object with correct associations" do
      @draft.reload
      @player.draft.should eql(@draft)
    end
  end

  describe "create with has-many association" do
    before(:each) do
      @divisions = 3.times.map { Division.create!(:name => "div #{Time.now.to_f}", :league => League.create!(:name => "league #{Time.now.to_f}")) }
      page.driver.post create_path(:model_name => "league", :league => {:name => "National League", :division_ids =>[@divisions[0].id]})
      @league = RailsAdmin::AbstractModel.new("League").all.last
    end

    it "should create an object with correct associations" do
      @divisions[0].reload
      @league.divisions.should include(@divisions[0])
      @league.divisions.should_not include(@divisions[1])
      @league.divisions.should_not include(@divisions[2])
    end
  end

  describe "create with has-and-belongs-to-many association" do
    before(:each) do
      @teams = 3.times.map { FactoryGirl.create :team }
      page.driver.post create_path(:model_name => "fan", :fan => {:name => "John Doe", :team_ids => [@teams[0].id] })
      @fan = RailsAdmin::AbstractModel.new("Fan").first
    end

    it "should create an object with correct associations" do
      @teams[0].reload
      @fan.teams.should include(@teams[0])
      @fan.teams.should_not include(@teams[1])
      @fan.teams.should_not include(@teams[2])
    end
  end

  describe "create with uniqueness constraint violated", :given => "a player exists" do
    before(:each) do
      @team = FactoryGirl.create :team
      @player = FactoryGirl.create :player, :team => @team

      page.driver.post create_path(:model_name => "player", :player => {:name => @player.name, :number => @player.number.to_s, :position => @player.position, :team_id => @team.id})
    end

    it "should show an error message" do
      should have_content("There is already a player with that number on this team")
    end
  end

  describe "create with invalid object" do
    before(:each) do
      page.driver.post(create_path(:model_name => "player", :id => 1), :params => {:player => {}})
    end

    it "should show an error message" do
      should have_content("Player failed to be created")
      should have_selector "form", :action => "/admin/players"
    end
  end

  describe "create with object with errors on base" do
    before(:each) do
      visit new_path(:model_name => "player")
      fill_in "player[name]", :with => "Jackie Robinson on steroids"
      click_button "Save and add another"
    end

    it "should show error base error message in flash" do
      should have_content("Player failed to be created. Player is cheating")
    end
  end
end
