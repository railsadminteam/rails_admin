require 'spec_helper'

describe "RailsAdmin Basic Update" do

  describe "update with errors" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should return to edit page" do
      fill_in "players[name]", :with => ""
      res = click_button "Save"
      res.should be_successful
      res.should have_tag "form", :action => "/admin/players/#{@player.id}"
    end
  end

  describe "update and add another" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
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

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
      @player.should be_suspended
    end
  end

  describe "update and edit" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "players[name]", :with => "Jackie Robinson"
      fill_in "players[number]", :with => "42"
      fill_in "players[position]", :with => "Second baseman"
      check "players[suspended]"

      @req = click_button "Save and edit"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
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
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      @draft = RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))

      get rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "players[name]", :with => "Jackie Robinson"
      fill_in "players[number]", :with => "42"
      fill_in "players[position]", :with => "Second baseman"

      select "Draft ##{@draft.id}"

      @req = click_button "Save"
      @player = RailsAdmin::AbstractModel.new("Player").first
      # @response = rails_admin_update, :model_name => "player", :id => @player.id), :put, :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :position => "Second baseman"}, :associations => {:draft => @draft.id}})
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
      @league = RailsAdmin::AbstractModel.new("League").create(:name => "League 1")

      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_edit_path(:model_name => "league", :id => @league.id)

      fill_in "leagues[name]", :with => "National League"

      set_hidden_field "associations[teams][]", :to => @teams[0].id.to_s.to_i

      response = click_button "Save"
      @league = RailsAdmin::AbstractModel.new("League").first
      @histories = RailsAdmin::History.where(:item => @league.id)
    end

    it "should update an object with correct attributes" do
      @league.name.should eql("National League")
    end

    it "should update an object with correct associations" do
      @teams[0].reload
      @league.teams.should include(@teams[0])
    end

    it "should not update an object with incorrect associations" do
      @league.teams.should_not include(@teams[1])
      @league.teams.should_not include(@teams[2])
    end

    it "should log a history message about the update" do
      @histories.collect(&:message).should include("Added Teams ##{@teams[0].id} associations, Changed name")
    end

    describe "removing has-many associations" do
      before(:each) do
        get rails_admin_edit_path(:model_name => "league", :id => @league.id)
        set_hidden_field "associations[teams][]", :to => nil
        response = click_button "Save"
        @league = RailsAdmin::AbstractModel.new("League").first
        @histories.reload
      end

      it "should have empty associations" do
        @league.teams.should be_empty
      end

      it "should log a message to history about removing associations" do
        @histories.collect(&:message).should include("Removed Teams ##{@teams[0].id} associations")
      end
    end
  end

  describe "update with has-and-belongs-to-many association" do
    before(:each) do
      @teams = (1..3).collect do |number|
        RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      @fan = RailsAdmin::AbstractModel.new("Fan").create(:name => "Fan 1")
      @fan.teams << @teams[0]

      get rails_admin_edit_path(:model_name => "fan", :id => @fan.id)
      set_hidden_field "associations[teams][]", :to => @teams[1].id.to_s.to_i
      response = click_button "Save"
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
      @response = visit(rails_admin_update_path(:model_name => "player", :id => 1), :put, {:player => {:name => "Jackie Robinson", :number => 42, :position => "Second baseman"}})
    end

    it "should raise NotFound" do
      @response.status.should equal(404)
    end
  end

  describe "update with invalid object" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "players[name]", :with => "Jackie Robinson"
      fill_in "players[number]", :with => "a"
      fill_in "players[position]", :with => "Second baseman"
      @req = click_button "Save"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should show an error message" do
      @req.body.should contain("Player failed to be updated")
    end
  end

  describe "update with serialized objects" do
    before(:each) do
      @user = RailsAdmin::AbstractModel.new("User").create(
        :email => "test@example.com",
        :password => "test1234",
        :password_confirmation => 'test1234')
      get rails_admin_edit_path(:model_name => "user", :id => @user.id)
      fill_in "users[roles]", :with => "[\"admin\", \"user\"]"
      @req = click_button "Save"
      @user = RailsAdmin::AbstractModel.new("User").model.find(@user.id)
    end

    it "should save the serialized data" do
      @user.roles.should eql(['admin','user'])
    end
  end

end
