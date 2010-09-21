require 'spec_helper'

describe "RailsAdmin" do
  include Warden::Test::Helpers
  
  before(:each) do
    RailsAdmin::AbstractModel.new("Division").destroy_all!
    RailsAdmin::AbstractModel.new("Draft").destroy_all!
    RailsAdmin::AbstractModel.new("League").destroy_all!
    RailsAdmin::AbstractModel.new("Player").destroy_all!
    RailsAdmin::AbstractModel.new("Team").destroy_all!
    RailsAdmin::AbstractModel.new("User").destroy_all!

    user = RailsAdmin::AbstractModel.new("User").create(
      :email => "test@test.com",
      :password => "test1234"
    )

    login_as user
  end
  
  after(:each) do
    Warden.test_reset!
  end

  describe "GET /admin" do
    before(:each) do
      get rails_admin_dashboard_path
    end

    it "should respond sucessfully" do
      response.code.should == "200"
    end

  end

  describe "GET /admin/player as list" do
    before(:each) do
      get rails_admin_list_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"Select model to edit\"" do
      response.body.should contain("Select player to edit")
    end

    it "should show filters" do
      response.body.should contain(/CREATED AT\n\s*UPDATED AT\n\s*/)
    end

    it "should show column headers" do
      response.body.should contain(/EDIT\n\s*DELETE\n\s*/)
    end
  end

  describe "GET /admin/player with sort" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      get rails_admin_list_path(:model_name => "player", :sort => "name", :set => 1)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should be sorted correctly" do
      response.body.should contain(/Sandy Koufax/)
      response.body.should contain(/Jackie Robinson/)
    end
  end

  describe "GET /admin/player with reverse sort" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      get rails_admin_list_path(:model_name => "player", :sort => "name", :sort_reverse => "true", :set => 1)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should be sorted correctly" do
      response.body.should contain(/Sandy Koufax/)
      response.body.should contain(/Jackie Robinson/)
    end
  end

  describe "GET /admin/player with query" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      get rails_admin_list_path(:model_name => "player", :query => "Jackie Robinson", :set => 1)
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show a correct result" do
      @response.body.should contain("Jackie Robinson")
    end

    it "should not contain an incorrect result" do
      @response.body.should_not contain("Sandy Koufax")
    end
  end

  describe "GET /admin/player with query and boolean filter" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher", :retired => true, :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman", :retired => true, :injured => false)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 18, :name => "Moises Alou", :position => "Left fielder", :retired => false, :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 5, :name => "David Wright", :position => "Third baseman", :retired => false, :injured => false)
      get rails_admin_list_path(:model_name => "player", :query => "Sandy Koufax", :filter => {:injured => "true"}, :set => 1)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show a correct result" do
      response.body.should contain("Sandy Koufax")
    end

    it "should not contain an incorrect result" do
      response.body.should_not contain("Jackie Robinson")
      response.body.should_not contain("Moises Alou")
      response.body.should_not contain("David Wright")
    end
  end

  describe "GET /admin/player with boolean filter" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 18, :name => "Moises Alou", :position => "Left fielder", :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 5, :name => "David Wright", :position => "Third baseman", :injured => false)
      get rails_admin_list_path(:model_name => "player", :filter => {:injured => "true"}, :set => 1)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show a correct result" do
      response.body.should contain("Moises Alou")
    end

    it "should not contain an incorrect result" do
      response.body.should_not contain("David Wright")
    end
  end

  describe "GET /admin/player with boolean filters" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher", :retired => true, :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman", :retired => true, :injured => false)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 18, :name => "Moises Alou", :position => "Left fielder", :retired => false, :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 5, :name => "David Wright", :position => "Third baseman", :retired => false, :injured => false)
      get rails_admin_list_path(:model_name => "player", :filter => {:retired => "true", :injured => "true"}, :set => 1)
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show a correct result" do
    end

    it "should not contain an incorrect result" do
      @response.body.should_not contain("Jackie Robinson")
      @response.body.should_not contain("Moises Alou")
      @response.body.should_not contain("David Wright")
    end
  end

  describe "GET /admin/player with 2 objects" do
    before(:each) do

      (1..2).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"2 results\"" do
      response.body.should contain("2 players")
    end
  end

  describe "GET /admin/player with 20 objects" do
    before(:each) do

      (1..20).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show \"20 results\"" do
      @response.body.should contain("20 players")
    end
  end

  describe "GET /admin/player with 20 objects, page 8" do
    before(:each) do
      per_page = 20
      page_numers = 20
      (1..per_page * page_numers).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player", :page => 8)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should paginate correctly" do
      response.body.should contain(/1 2 [^0-9]*5 6 7 8 9 10 11[^0-9]*19 20/)
    end
  end

  describe "list with 20 objects, page 17" do
    before(:each) do
      per_page = 20
      max_pages = 20
      (1..per_page * max_pages).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player", :page => 18)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should paginate correctly" do
      @response.body.should contain(/1 2[^0-9]*12 13 14 15 16 17 18 19 20/)
    end
  end

  describe "GET /admin/player show all" do
    before(:each) do
      (1..2).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player", :all => true)
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  #new

  describe "GET /admin/player/new" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"New model\"" do
      response.body.should contain("New player")
    end

    it "should show required fields as \"Required\"" do
      response.body.should contain(/Name\n\s*Required/)
      response.body.should contain(/Number\n\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      response.body.should contain(/Position\n\s*Optional/)
      response.body.should contain(/Born on\n\s*Optional/)
      response.body.should contain(/Notes\n\s*Optional/)
    end
  end

  describe "GET /admin/player/new with has-one association" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))
      get rails_admin_new_path(:model_name => "player")

    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Draft #\d+/)
    end
  end

  describe "GET /admin/player/new with has-many association" do
    before(:each) do
      (1..3).each do |number|
        RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Team 1Team 2Team 3/)
    end
  end

  pending"GET /admin/team/:id/fans/new with has-and-belongs-to-many association" do
    before(:each) do
      (1..3).each do |number|
        RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_new_path(:model_name => "team")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Team 1/)
    end
  end

  describe "GET /admin/player/new with missing label" do
    before(:each) do
      (1..3).each do |number|
        RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end
  end

  describe "create" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"

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
    end
  end

  describe "create and edit" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")
      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
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
    end
  end

  describe "create and add another" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")
      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
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
    end
  end

  describe "create with has-one association" do
    before(:each) do
      @draft = RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))
      get rails_admin_new_path(:model_name => "player")
      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => 42
      fill_in "player[position]", :with => "Second baseman"
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

      fill_in "league[name]", :with => "National League"

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

  pending "create with has-and-belongs-to-many association" do
    before(:each) do
      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_new_path(:model_name => "league")

      fill_in "league[name]", :with => "National League"

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

      fill_in "player[name]", :with => @player.name
      fill_in "player[number]", :with => @player.number.to_s
      fill_in "player[position]", :with => @player.position
      select "#{@team.name}", :from => "player[team_id]"

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
    end
  end

  describe "edit" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"Edit model\"" do
      response.body.should contain("Edit player")
    end

    it "should show required fields as \"Required\"" do
      response.body.should contain(/Name\n\s*Required/)
      response.body.should contain(/Number\n\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      response.body.should contain(/Position\n\s*Optional/)
      response.body.should contain(/Born on\n\s*Optional/)
      response.body.should contain(/Notes\n\s*Optional/)
    end
  end

  describe "edit with has-one association" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      @draft = RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))

      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
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
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Team 1Team 2Team 3/)
    end
  end

  pending "edit with has-and-belongs-to-many association" do
    before(:each) do
      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Team 1Team 2Team 3/)
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
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end
  end

  describe "update and add another" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"

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
    end
  end

  describe "update and edit" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"

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
    end
  end

  describe "update with has-one association" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      @draft = RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))

      get rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"

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

      fill_in "league[name]", :with => "National League"

      set_hidden_field "associations[teams][]", :to => @teams[0].id.to_s.to_i

      response = click_button "Save"
      @league = RailsAdmin::AbstractModel.new("League").first
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
  end

  pending "update with has-many association", :given => ["a league exists", "three teams exist"] do
    before(:each) do
      @league = RailsAdmin::AbstractModel.new("League").create(:name => "League 1")

      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_edit_path(:model_name => "league", :id => @league.id)

      fill_in "league[name]", :with => "National League"

      set_hidden_field "associations[teams][]", :to => @teams[0].id.to_s.to_i

      response = click_button "Save"
      @league = RailsAdmin::AbstractModel.new("League").first
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

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "a"
      fill_in "player[position]", :with => "Second baseman"
      @req = click_button "Save"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should show an error message" do
      @req.body.should contain("Player failed to be updated")
    end
  end

  describe "delete" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_delete_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"Delete model\"" do
      response.body.should contain("Delete player")
    end
  end

  describe "delete with missing object" do
    before(:each) do
      get rails_admin_delete_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      @response.status.should equal(404)
    end
  end

  describe "delete with missing label" do
    before(:each) do
      @league = RailsAdmin::AbstractModel.new("League").create(:name => "League 1")
      @team = RailsAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => rand(99999), :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)

      get rails_admin_delete_path(:model_name => "league", :id => @league.id)
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  describe "destroy" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")

      get rails_admin_delete_path(:model_name => "player", :id => @player.id)

      @req = click_button "Yes, I'm sure"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should destroy an object" do
      @player.should be_nil
    end
  end

  describe "destroy" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")

      get rails_admin_delete_path(:model_name => "player", :id => @player.id)

      @req = click_button "Cancel"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should destroy an object" do
      @player.should_not be_nil
    end
  end

  describe "destroy with missing object" do
    before(:each) do
      @req = visit(rails_admin_destroy_path(:model_name => "player", :id => 1), :delete)
    end

    it "should raise NotFound" do
      @req.status.should equal(404)
    end
  end

end
