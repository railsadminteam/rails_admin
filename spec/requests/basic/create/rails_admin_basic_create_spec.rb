require 'spec_helper'

describe "RailsAdmin Basic Create" do

  describe "create" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")

      fill_in "players[name]", :with => "Jackie Robinson"
      fill_in "players[number]", :with => "42"
      fill_in "players[position]", :with => "Second baseman"
      check "players[suspended]"

      @req = click_button "Save"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
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
      get rails_admin_new_path(:model_name => "player")
      fill_in "players[name]", :with => "Jackie Robinson"
      fill_in "players[number]", :with => "42"
      fill_in "players[position]", :with => "Second baseman"
      check "players[suspended]"
      @req = click_button "Save and edit"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @response.should be_successful
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
      get rails_admin_new_path(:model_name => "player")
      fill_in "players[name]", :with => "Jackie Robinson"
      fill_in "players[number]", :with => "42"
      fill_in "players[position]", :with => "Second baseman"
      check "players[suspended]"
      @req = click_button "Save and add another"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
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
      @draft = RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))
      get rails_admin_new_path(:model_name => "player")
      fill_in "players[name]", :with => "Jackie Robinson"
      fill_in "players[number]", :with => 42
      fill_in "players[position]", :with => "Second baseman"
      select "Draft ##{@draft.id}"
      @req = click_button "Save"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should create an object with correct associations" do
      @draft.reload
      @player.draft.should eql(@draft)
    end
  end

  describe "create with has-many association" do
    before(:each) do
      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_new_path(:model_name => "league")

      fill_in "leagues[name]", :with => "National League"

      set_hidden_field "associations[teams][]", :to => @teams[0].id.to_s.to_i
      @req = click_button "Save"

      @league = RailsAdmin::AbstractModel.new("League").first
    end

    it "should create an object with correct associations" do
      @teams[0].reload
      @league.teams.should include(@teams[0])
    end

    it "should not create an object with incorrect associations" do
      @league.teams.should_not include(@teams[1])
      @league.teams.should_not include(@teams[2])
    end
  end

  describe "create with has-and-belongs-to-many association" do
    before(:each) do
      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_new_path(:model_name => "league")

      fill_in "leagues[name]", :with => "National League"

      set_hidden_field "associations[teams][]", :to => @teams[0].id.to_s.to_i
      @req = click_button "Save"

      @league = RailsAdmin::AbstractModel.new("League").first
    end

    it "should create an object with correct associations" do
      @teams[0].reload
      @league.teams.should include(@teams[0])
    end

    it "should not create an object with incorrect associations" do
      @league.teams.should_not include(@teams[1])
      @league.teams.should_not include(@teams[2])
    end
  end

  describe "create with uniqueness constraint violated", :given => "a player exists" do
    before(:each) do
      @team =  RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")

      get rails_admin_new_path(:model_name => "player")

      fill_in "players[name]", :with => @player.name
      fill_in "players[number]", :with => @player.number.to_s
      fill_in "players[position]", :with => @player.position
      select "#{@team.name}", :from => "players[team_id]"

      @req = click_button "Save"
    end

    it "should show an error message" do
      @req.body.should contain("There is already a player with that number on this team")
    end
  end

  describe "create with invalid object" do
    before(:each) do
        @response = visit(rails_admin_create_path(:model_name => "player"), :post, :params => {:player => {}})
    end

    it "should show an error message" do
      @response.body.should contain("Player failed to be created")
      @response.body.should have_tag "form", :action => "/admin/players"
    end
  end
end
