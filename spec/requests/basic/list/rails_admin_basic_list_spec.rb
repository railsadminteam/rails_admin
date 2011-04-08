require 'spec_helper'

describe "RailsAdmin Basic List" do

  describe "GET /admin" do
    before(:each) do
      get rails_admin_dashboard_path
    end

    it "should respond successfully" do
      response.should be_successful
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

    it "should show column headers" do
      response.body.should contain(/EDIT\n\s*DELETE\n\s*/)
    end
  end

  describe "GET /admin/player with sort" do
    before(:each) do
      @players = 2.times.map { Factory.create :player }
      get rails_admin_list_path(:model_name => "player", :sort => "name", :set => 1)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should be sorted correctly" do
      2.times { |i| response.body.should contain(/#{@players[i].name}/) }
    end
  end

  describe "GET /admin/player with reverse sort" do

    before(:each) do
      @players = 2.times.map { Factory.create :player }
      get rails_admin_list_path(:model_name => "player", :sort => "name", :sort_reverse => "true", :set => 1)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should be sorted correctly" do
      2.times { |i| response.body.should contain(/#{@players.reverse[i].name}/) }
    end
  end

  describe "GET /admin/player with field search" do
    before(:each) do
      @players = 2.times.map { Factory.create :player }
      get rails_admin_list_path(:model_name => "player", :query => "number:#{@players[0].number}", :set => 1)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show a correct result" do
      response.body.should contain(@players[0].name)
    end

    it "should not contain an incorrect result" do
      response.body.should_not contain(@players[1].name)
    end
  end

  describe "GET /admin/player with query" do
    before(:each) do
      @players = 2.times.map { Factory.create :player }
      get rails_admin_list_path(:model_name => "player", :query => @players[0].name, :set => 1)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show a correct result" do
      response.body.should contain(@players[0].name)
    end

    it "should not contain an incorrect result" do
      response.body.should_not contain(@players[1].name)
    end
  end

  describe "GET /admin/player with query and boolean filter" do
    before(:each) do
      @players = [
        Factory.create(:player, :injured => true),
        Factory.create(:player, :injured => false),
        Factory.create(:player, :injured => true),
        Factory.create(:player, :injured => false),
      ]
      get rails_admin_list_path(:model_name => "player", :query => @players[0].name, :filter => {:injured => "true"}, :set => 1)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show a correct result" do
      response.body.should contain(@players[0].name)
    end

    it "should not contain an incorrect result" do
      (1..3).each do |i|
        response.body.should_not contain(@players[i].name)
      end
    end
  end

  describe "GET /admin/player with boolean filter" do
    before(:each) do
      @players = [
        Factory.create(:player, :injured => true),
        Factory.create(:player, :injured => false),
      ]
      get rails_admin_list_path(:model_name => "player", :filter => {:injured => "true"}, :set => 1)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show a correct result" do
      response.body.should contain(@players[0].name)
    end

    it "should not contain an incorrect result" do
      response.body.should_not contain(@players[1].name)
    end
  end

  describe "GET /admin/player with boolean filters" do
    before(:each) do
      @players = [
        Factory.create(:player, :retired => true, :injured => true),
        Factory.create(:player, :retired => true, :injured => false),
        Factory.create(:player, :retired => false, :injured => true),
        Factory.create(:player, :retired => false, :injured => false),
      ]
      get rails_admin_list_path(:model_name => "player", :filter => {:retired => "true", :injured => "true"}, :set => 1)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show a correct result" do
      response.body.should contain(@players[0].name)
    end

    it "should not contain an incorrect result" do
      (1..3).each do |i|
        response.body.should_not contain(@players[i].name)
      end
    end
  end

  describe "GET /admin/player with 2 objects" do
    before(:each) do
      @players = 2.times.map { Factory.create :player }
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
      @players = 20.times.map { Factory.create :player }
      get rails_admin_list_path(:model_name => "player")
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show \"20 results\"" do
      response.body.should contain("20 players")
    end
  end

  describe "GET /admin/player with 20 pages, page 8" do
    before(:each) do
      items_per_page = RailsAdmin::Config::Sections::List.default_items_per_page
      (items_per_page * 20).times { Factory.create(:player) }
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
      items_per_page = RailsAdmin::Config::Sections::List.default_items_per_page
      (items_per_page * 20).times { Factory.create(:player) }
      get rails_admin_list_path(:model_name => "player", :page => 18)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should paginate correctly" do
      response.body.should contain(/1 2[^0-9]*12 13 14 15 16 17 18 19 20/)
    end
  end

  describe "GET /admin/player show all" do
    before(:each) do
      2.times.map { Factory.create :player }
      get rails_admin_list_path(:model_name => "player", :all => true)
    end

    it "should respond successfully" do
      response.should be_successful
    end
  end
end