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
      21.times { FactoryGirl.create :player } # two pages of players
      get rails_admin_list_path(:model_name => "player")
    end

    it "should show \"Select model to edit\", should show filters and should show column headers" do
      response.should be_successful
      response.body.should contain("Select player to edit")
      response.body.should contain(/CREATED AT\n\s*UPDATED AT\n\s*/)
    end
    
    it "shows the edit and delete links" do
      response.body.should have_selector("td a img[alt='Edit']")
      response.body.should have_selector("td a img[alt='Delete']")
    end
    
    it "has the search box with some prompt text" do
      response.body.should have_selector("input#search[placeholder='Search']")
    end

    # https://github.com/sferik/rails_admin/issues/362
    # test that no link uses the "wildcard route" with the main
    # controller and list method
    it "should not use the 'wildcard route'" do
      assert_tag "a", :attributes => {:href => /all=true/} # make sure we're fully testing pagination
      assert_no_tag "a", :attributes => {:href => /^\/rails_admin\/main\/list/}
    end
  end

  describe "GET /admin/player with sort" do
    before(:each) do
      @players = 2.times.map { FactoryGirl.create :player }
      get rails_admin_list_path(:model_name => "player", :sort => "name", :set => 1)
    end

    it "should be sorted correctly" do
      response.should be_successful
      2.times { |i| response.body.should contain(/#{@players[i].name}/) }
    end
  end

  describe "GET /admin/player with reverse sort" do

    before(:each) do
      @players = 2.times.map { FactoryGirl.create :player }
      get rails_admin_list_path(:model_name => "player", :sort => "name", :sort_reverse => "true", :set => 1)
    end

    it "should be sorted correctly" do
      response.should be_successful
      2.times { |i| response.body.should contain(/#{@players.reverse[i].name}/) }
    end
  end

  describe "GET /admin/player" do
    before(:each) do
      @teams = 2.times.map do
        FactoryGirl.create(:team)
      end
      @players = [
        FactoryGirl.create(:player, :retired => true, :injured => true, :team => @teams[0]),
        FactoryGirl.create(:player, :retired => true, :injured => false, :team => @teams[0]),
        FactoryGirl.create(:player, :retired => false, :injured => true, :team => @teams[1]),
        FactoryGirl.create(:player, :retired => false, :injured => false, :team => @teams[1]),
      ]
    end
    
    it "should allow to query on any attribute" do
      get rails_admin_list_path(:model_name => "player", :query => @players[0].name, :set => 1)
      response.body.should contain(@players[0].name)
      (1..3).each do |i|
        response.body.should_not contain(@players[i].name)
      end
    end

    it "should allow to filter on one attribute" do
      get rails_admin_list_path(:model_name => "player", :filters => {:injured => {"1" => {:value => "true"}}}, :set => 1)
      response.body.should contain(@players[0].name)
      response.body.should_not contain(@players[1].name)
      response.body.should contain(@players[2].name)
      response.body.should_not contain(@players[3].name)
    end
    
    it "should allow to combine filters on two different attributes" do
      get rails_admin_list_path(:model_name => "player", :filters => {:retired => {"1" => {:value => "true"}}, :injured => {"1" => {:value => "true"}}}, :set => 1)
      response.body.should contain(@players[0].name)
      (1..3).each do |i|
        response.body.should_not contain(@players[i].name)
      end
    end
    
    it "should allow to filter on belongs_to relationships" do
      get rails_admin_list_path(:model_name => "player", :filters => {:team_id => {"1" => { :value => @teams[0].name }}}, :set => 1)
      response.body.should contain(@players[0].name)
      response.body.should contain(@players[1].name)
      response.body.should_not contain(@players[2].name)
      response.body.should_not contain(@players[3].name)
    end
    
    it "should allow to disable search on attributes" do
      RailsAdmin.config Player do
        list do
          field :position
          field :name do
            searchable false
          end
        end
      end
      get rails_admin_list_path(:model_name => "player", :query => @players[0].name)
      response.body.should_not contain(@players[0].name)
    end
    
    it "should allow to search a belongs_to attribute over the base table" do
      RailsAdmin.config Player do
        list do
          field :id
          field :name
          field :team_id do
            searchable({ Player => :team_id })
          end
        end
      end
      get rails_admin_list_path(:model_name => "player", :filters => {:team_id => {"1" => {:value => @teams.first.id}}})
      response.body.should contain(@players[0].name)
      response.body.should contain(@players[1].name)
      response.body.should_not contain(@players[2].name)
      response.body.should_not contain(@players[3].name)
    end


    it "should allow to search a belongs_to attribute over the target table" do
      RailsAdmin.config Player do
        list do
          field :id
          field :name
          field :team_id do
            searchable({ Team => :name })
          end
        end
      end
      get rails_admin_list_path(:model_name => "player", :filters => {:team_id => {"1" => {:value => @teams.first.name}}})
      response.body.should contain(@players[0].name)
      response.body.should contain(@players[1].name)
      response.body.should_not contain(@players[2].name)
      response.body.should_not contain(@players[3].name)
    end

    it "should allow to search a belongs_to attribute over the label method by default" do
      RailsAdmin.config Player do
        list do
          field :id
          field :name
          field :team_id
        end
      end
      get rails_admin_list_path(:model_name => "player", :filters => {:team_id => {"1" => {:value => @teams.first.name}}})
      response.body.should contain(@players[0].name)
      response.body.should contain(@players[1].name)
      response.body.should_not contain(@players[2].name)
      response.body.should_not contain(@players[3].name)
    end

    it "should allow to search a belongs_to attribute over the target table when an attribute is specified" do
      RailsAdmin.config Player do
        list do
          field :id
          field :name
          field :team_id do
            searchable :name
          end
        end
      end
      get rails_admin_list_path(:model_name => "player", :filters => {:team_id => {"1" => {:value => @teams.first.name}}})
      response.body.should contain(@players[0].name)
      response.body.should contain(@players[1].name)
      response.body.should_not contain(@players[2].name)
      response.body.should_not contain(@players[3].name)
    end
    
    it "should allow to search over more than one attribute" do
      RailsAdmin.config Player do
        list do
          field :id
          field :name
          field :team_id do
            searchable [:name, {Player => :team_id}]
          end
        end
      end
      get rails_admin_list_path(:model_name => "player", :filters => {:team_id => {"1" => {:value => @teams.first.name}, "2" => {:value => @teams.first.id}}})
      response.body.should contain(@players[0].name)
      response.body.should contain(@players[1].name)
      response.body.should_not contain(@players[2].name)
      response.body.should_not contain(@players[3].name)
      # same with a different id
      get rails_admin_list_path(:model_name => "player", :filters => {:team_id => {"1" => {:value => @teams.first.name}, "2" => {:value => @teams.last.id}}})
      response.body.should_not contain(@players[0].name)
      response.body.should_not contain(@players[1].name)
      response.body.should_not contain(@players[2].name)
      response.body.should_not contain(@players[3].name)
    end
  end

  describe "GET /admin/player with 2 objects" do
    before(:each) do
      @players = 2.times.map { FactoryGirl.create :player }
      get rails_admin_list_path(:model_name => "player")
    end

    it "should show \"2 results\"" do
      response.should be_successful
      response.body.should contain("2 players")
    end
  end

  describe "GET /admin/player with 20 objects" do
    before(:each) do
      @players = 20.times.map { FactoryGirl.create :player }
      get rails_admin_list_path(:model_name => "player")
    end

    it "should show \"20 results\"" do
      response.should be_successful
      response.body.should contain("20 players")
    end
  end

  describe "GET /admin/player with 20 pages, page 8" do
    before(:each) do
      items_per_page = RailsAdmin::Config::Sections::List.default_items_per_page
      (items_per_page * 20).times { FactoryGirl.create(:player) }
      get rails_admin_list_path(:model_name => "player", :page => 8)
    end

    it "should paginate correctly" do
      response.should be_successful
      response.body.should contain(/1 2 [^0-9]*5 6 7 8 9 10 11[^0-9]*19 20/)
    end
  end

  describe "list with 20 pages, page 20" do
    before(:each) do
      items_per_page = RailsAdmin::Config::Sections::List.default_items_per_page
      @players = (items_per_page * 20).times.map { FactoryGirl.create(:player) }
      get rails_admin_list_path(:model_name => "player", :page => 20)
    end

    it "should paginate correctly and contain the right item" do
      response.should be_successful
      response.body.should contain(/1 2[^0-9]*12 13 14 15 16 17 18 19 20/)
    end
  end

  describe "GET /admin/player show all" do
    before(:each) do
      2.times.map { FactoryGirl.create :player }
      get rails_admin_list_path(:model_name => "player", :all => true)
    end

    it "should respond successfully" do
      response.should be_successful
    end
  end

  describe "list as compact json" do
    before(:each) do
      2.times.map { FactoryGirl.create :player }
      get rails_admin_list_path(:model_name => "player", :compact => true, :format => :json)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should contain an array with 2 elements and contain an array of elements with keys id and label" do
      ActiveSupport::JSON.decode(response.body).length.should eql(2)
      ActiveSupport::JSON.decode(response.body).each do |object|
        object.should have_key("id")
        object.should have_key("label")
      end
    end
  end
end
