# coding: utf-8

require 'spec_helper'

describe "RailsAdmin Basic List" do

  subject { page }

  describe "GET /admin" do
    it "should respond successfully" do
      visit dashboard_path
    end
  end

  describe "GET /admin/typo" do
    it "should redirect to dashboard and inform the user the model wasn't found" do
      visit '/admin/whatever'
      page.driver.status_code.should eql(404)
      find('.alert-error').should have_content("Model 'Whatever' could not be found")
    end
  end

  describe "GET /admin/balls/545-typo" do
    it "should redirect to balls index and inform the user the id wasn't found" do
      visit '/admin/ball/545-typo'
      page.driver.status_code.should eql(404)
      find('.alert-error').should have_content("Ball with id '545-typo' could not be found")
    end
  end

  describe "GET /admin/player as list" do
    before do
      21.times { FactoryGirl.create :player } # two pages of players
      visit index_path(:model_name => "player")
    end

    it "should show \"List of Models\", should show filters and should show column headers" do
      should have_content("List of Players")
      should have_content("Created at")
      should have_content("Updated at")

      # it "shows the show, edit and delete links" do
      should have_selector("td a", :text => 'Show')
      should have_selector("td a", :text => 'Edit')
      should have_selector("td a", :text => 'Delete')

      # it "has the search box with some prompt text" do
      should have_selector("input[placeholder='Filter']")

      # https://github.com/sferik/rails_admin/issues/362
      # test that no link uses the "wildcard route" with the main
      # controller and list method
      # it "should not use the 'wildcard route'" do
      should have_selector("a[href*='all=true']") # make sure we're fully testing pagination
      should have_no_selector("a[href^='/rails_admin/main/list']")
    end
  end

  describe "GET /admin/player" do
    before do
      RailsAdmin.config Player do
        list do
          field :name
          field :team
          field :injured
          field :retired
        end
      end
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
      visit index_path(:model_name => "player", :query => @players[0].name)
      should have_content(@players[0].name)
      (1..3).each do |i|
        should have_no_content(@players[i].name)
      end
    end

    it "should allow to filter on one attribute" do
      visit index_path(:model_name => "player", :f => {:injured => {"1" => {:v => "true"}}})
      should have_content(@players[0].name)
      should have_no_content(@players[1].name)
      should have_content(@players[2].name)
      should have_no_content(@players[3].name)
    end

    it "should allow to combine filters on two different attributes" do
      visit index_path(:model_name => "player", :f => {:retired => {"1" => {:v => "true"}}, :injured => {"1" => {:v => "true"}}})
      should have_content(@players[0].name)
      (1..3).each do |i|
        should have_no_content(@players[i].name)
      end
    end

    it "should allow to filter on belongs_to relationships" do
      visit index_path(:model_name => "player", :f => {:team => {"1" => { :v => @teams[0].name }}})
      should have_content(@players[0].name)
      should have_content(@players[1].name)
      should have_no_content(@players[2].name)
      should have_no_content(@players[3].name)
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
      visit index_path(:model_name => "player", :query => @players[0].name)
      should have_no_content(@players[0].name)
    end

    it "should allow to search a belongs_to attribute over the base table" do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable Player => :team_id
          end
        end
      end
      visit index_path(:model_name => "player", :f => {:team => {"1" => {:v => @teams.first.id}}})
      should have_content(@players[0].name)
      should have_content(@players[1].name)
      should have_no_content(@players[2].name)
      should have_no_content(@players[3].name)
    end


    it "should allow to search a belongs_to attribute over the target table" do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable Team => :name
          end
        end
      end
      visit index_path(:model_name => "player", :f => {:team => {"1" => {:v => @teams.first.name}}})
      should have_content(@players[0].name)
      should have_content(@players[1].name)
      should have_no_content(@players[2].name)
      should have_no_content(@players[3].name)
    end

    it "should allow to search a belongs_to attribute over the target table with a table name specified as a hash" do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable :teams => :name
          end
        end
      end
      visit index_path(:model_name => "player", :f => {:team => {"1" => {:v => @teams.first.name}}})
      should have_content(@players[0].name)
      should have_content(@players[1].name)
      should have_no_content(@players[2].name)
      should have_no_content(@players[3].name)
    end

    it "should allow to search a belongs_to attribute over the target table with a table name specified as a string" do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable 'teams.name'
          end
        end
      end
      visit index_path(:model_name => "player", :f => {:team => {"1" => {:v => @teams.first.name}}})
      should have_content(@players[0].name)
      should have_content(@players[1].name)
      should have_no_content(@players[2].name)
      should have_no_content(@players[3].name)
    end

    it "should allow to search a belongs_to attribute over the label method by default" do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team
        end
      end
      visit index_path(:model_name => "player", :f => {:team => {"1" => {:v => @teams.first.name}}})
      should have_content(@players[0].name)
      should have_content(@players[1].name)
      should have_no_content(@players[2].name)
      should have_no_content(@players[3].name)
    end

    it "should allow to search a belongs_to attribute over the target table when an attribute is specified" do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable :name
          end
        end
      end
      visit index_path(:model_name => "player", :f => {:team => {"1" => {:v => @teams.first.name}}})
      should have_content(@players[0].name)
      should have_content(@players[1].name)
      should have_no_content(@players[2].name)
      should have_no_content(@players[3].name)
    end

    it "should allow to search over more than one attribute" do
      RailsAdmin.config Player do
        list do
          field PK_COLUMN
          field :name
          field :team do
            searchable [:name, {Player => :team_id}]
          end
        end
      end
      visit index_path(:model_name => "player", :f => {:team => {"1" => {:v => @teams.first.name}, "2" => {:v => @teams.first.id, :o => 'is'}}})
      should have_content(@players[0].name)
      should have_content(@players[1].name)
      should have_no_content(@players[2].name)
      should have_no_content(@players[3].name)
      # same with a different id
      visit index_path(:model_name => "player", :f => {:team => {"1" => {:v => @teams.first.name}, "2" => {:v => @teams.last.id, :o => 'is'}}})
      should have_no_content(@players[0].name)
      should have_no_content(@players[1].name)
      should have_no_content(@players[2].name)
      should have_no_content(@players[3].name)
    end

    it "should display base filters when no filters are present in the params" do
      RailsAdmin.config Player do
        list do
          filters [:name, :team]
        end
      end

      visit index_path(:model_name => "player")
      should have_content(%{$.filters.append("Name", "name", "string", null, null, "", 1);})
      should have_content(%{$.filters.append("Team", "team", "belongs_to_association", null, null, "", 2);})
    end
  end

  describe "GET /admin/player with 2 objects" do
    before(:each) do
      @players = 2.times.map { FactoryGirl.create :player }
      visit index_path(:model_name => "player")
    end

    it "should show \"2 results\"" do
      should have_content("2 players")
    end
  end

  describe "GET /admin/player with 20 objects" do
    before(:each) do
      @players = 20.times.map { FactoryGirl.create :player }
      visit index_path(:model_name => "player")
    end

    it "should show \"20 results\"" do
      should have_content("20 players")
    end
  end

  describe "GET /admin/player with 20 pages, page 8" do
    before(:each) do
      items_per_page = RailsAdmin.config.default_items_per_page
      (items_per_page * 20).times { FactoryGirl.create(:player) }
      visit index_path(:model_name => "player", :page => 8)
    end

    it "should paginate correctly" do
      find('.pagination ul li:first').should have_content("« Prev")
      find('.pagination ul li:last').should have_content("Next »")
      find('.pagination ul li.active').should have_content("8")
    end
  end

  describe "list with 20 pages, page 20" do
    before(:each) do
      items_per_page = RailsAdmin.config.default_items_per_page
      @players = (items_per_page * 20).times.map { FactoryGirl.create(:player) }
      visit index_path(:model_name => "player", :page => 20)
    end

    it "should paginate correctly and contain the right item" do
      find('.pagination ul li:first').should have_content("« Prev")
      find('.pagination ul li:last').should have_content("Next »")
      find('.pagination ul li.active').should have_content("20")
    end
  end

  describe "GET /admin/player show all" do
    it "should respond successfully" do
      2.times.map { FactoryGirl.create :player }
      visit index_path(:model_name => "player", :all => true)
    end
  end

  describe "list as compact json" do
    it "should have_content an array with 2 elements and contain an array of elements with keys id and label" do
      2.times.map { FactoryGirl.create :player }
      response = page.driver.get(index_path(:model_name => "player", :compact => true, :format => :json))
      ActiveSupport::JSON.decode(response.body).length.should eql(2)
      ActiveSupport::JSON.decode(response.body).each do |object|
        object.should have_key("id")
        object.should have_key("label")
      end
    end
  end

  describe "search operator" do
    let(:player) { FactoryGirl.create :player }

    before do
      Player.count.should == 0
    end

    it "finds the player if the query matches the default search opeartor" do
      RailsAdmin.config do |config|
        config.default_search_operator = 'ends_with'
        config.model Player do
          list { field :name }
        end
      end
      visit index_path(:model_name => "player", :query => player.name[2, -1])
      should have_content(player.name)
    end

    it "does not find the player if the query does not match the default search opeartor" do
      RailsAdmin.config do |config|
        config.default_search_operator = 'ends_with'
        config.model Player do
          list { field :name }
        end
      end
      visit index_path(:model_name => "player", :query => player.name[0, 2])
      should have_no_content(player.name)
    end

    it "finds the player if the query matches the specified search operator" do
      RailsAdmin.config Player do
        list do
          field :name do
            search_operator 'starts_with'
          end
        end
      end
      visit index_path(:model_name => "player", :query => player.name[0, 2])
      should have_content(player.name)
    end

    it "does not find the player if the query does not match the specified search operator" do
      RailsAdmin.config Player do
        list do
          field :name do
            search_operator 'starts_with'
          end
        end
      end
      visit index_path(:model_name => "player", :query => player.name[1..-1])
      should have_no_content(player.name)
    end
  end

  describe "list for objects with overridden to_param" do
    before(:each) do
      @ball = FactoryGirl.create :ball

      visit index_path(:model_name => "ball")
    end

    it "shows the show, edit and delete links with valid url" do
      should have_selector("td a[href='/admin/ball/#{@ball.id}']")
      should have_selector("td a[href='/admin/ball/#{@ball.id}/edit']")
      should have_selector("td a[href='/admin/ball/#{@ball.id}/delete']")
    end

  end

end
