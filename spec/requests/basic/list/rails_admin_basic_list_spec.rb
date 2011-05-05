require 'spec_helper'

describe "RailsAdmin Basic List" do

  describe "GET /admin" do
    before(:each) do
      get rails_admin_dashboard_path
    end

    it "should respond successfully" do
      response.code.should == "200"
    end

  end

  describe "GET /admin/player as list" do
    before(:each) do
      get rails_admin_list_path(:model_name => "player")
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show \"Select model to edit\"" do
      response.body.should contain("Select player to edit")
    end

    it "should show filters" do
      response.body.should contain(/CREATED AT\n\s*UPDATED AT\n\s*/)
    end

    pending "should show column headers" do
      # We now have little icons too small to have big text headers.
      response.body.should contain(/EDIT\n\s*DELETE\n\s*/)
    end
  end

  describe "GET /admin/player with sort" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      get rails_admin_list_path(:model_name => "player", :sort => "name", :set => 1)
    end

    it "should respond successfully" do
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

    it "should respond successfully" do
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

    it "should respond successfully" do
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

    it "should respond successfully" do
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

    it "should respond successfully" do
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

    it "should respond successfully" do
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

    it "should respond successfully" do
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

    it "should respond successfully" do
      @response.should be_successful
    end

    it "should show \"20 results\"" do
      @response.body.should contain("20 players")
    end
  end

  describe "GET /admin/player with 20 pages, page 8" do
    before(:each) do
      per_page = 20
      page_numers = 20
      (1..per_page * page_numers).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player", :page => 8)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should paginate correctly" do
      response.body.should contain(/1 2 [^0-9]*5 6 7 8 9 10 11[^0-9]*19 20/)
    end
  end

  describe "list with 20 pages, page 17" do
    before(:each) do
      per_page = 20
      max_pages = 20
      (1..per_page * max_pages).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player", :page => 18)
    end

    it "should respond successfully" do
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

    it "should respond successfully" do
      @response.should be_successful
    end
  end
end
