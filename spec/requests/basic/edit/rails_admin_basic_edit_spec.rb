require 'spec_helper'

describe "RailsAdmin Basic Edit" do

  describe "edit" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show \"Update model\"" do
      response.body.should contain("Update player")
    end

    it "should show required fields as \"Required\"" do
      response.body.should contain(/Name\n\s*Required/)
      response.body.should contain(/Number\n\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      response.body.should have_tag(".player_position .help", :content => "Optional")
      response.body.should have_tag(".player_born_on .help", :content => "Optional")
      response.body.should have_tag(".player_notes .help", :content => "Optional")
    end
  end

  describe "edit with has-one association" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      @draft = RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))

      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Draft #\d+/)
    end
  end

  describe "edit with has-many association" do
    before(:each) do
      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Team 1Team 2Team 3/)
    end
  end

  describe "edit with has-and-belongs-to-many association" do
    before(:each) do
      teams = (1..3).collect do |number|
        RailsAdmin::AbstractModel.new("Team").create(:division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      fan = RailsAdmin::AbstractModel.new("Fan").create(:name => "Fan 1")
      fan.teams << teams[0]
      get rails_admin_edit_path(:model_name => "fan", :id => fan.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should have_tag "#associations_teams" do |select|
        select[0].should have_selector 'option[selected="selected"]'
        select[1].should_not have_selector 'option[selected="selected"]'
        select[2].should_not have_selector 'option[selected="selected"]'
      end
    end
  end
  
  describe "edit with missing object" do
    before(:each) do
      get rails_admin_edit_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      response.status.should equal(404)
    end
  end

  describe "edit with missing label", :given => ["a player exists", "three teams with no name exist"] do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")

      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:division_id => rand(99999), :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end
  end
end
