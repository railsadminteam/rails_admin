require 'spec_helper'

describe "RailsAdmin Basic Edit" do

  subject { page }

  describe "edit" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit edit_path(:model_name => "player", :id => @player.id)
    end

    it "shows \"Edit model\"" do
      should have_content("Edit Player")
    end

    it "shows required fields as \"Required\"" do
      should have_selector("div", :text => /Name\s*Required/)
      should have_selector("div", :text => /Number\s*Required/)
    end

    it "shows non-required fields as \"Optional\"" do
      expect(find("#player_position_field .help-block")).to have_content("Optional")
      expect(find("#player_born_on_field .help-block")).to have_content("Optional")
      expect(find("#player_notes_field .help-block")).to have_content("Optional")
    end
  end

  describe "association with inverse_of option" do
    it "adds a related id to the belongs_to create team link" do
      @player = FactoryGirl.create :player
      visit edit_path(:model_name => "player", :id => @player.id)
      should have_selector("a[data-link='/admin/team/new?associations%5Bplayers%5D=#{@player.id.to_s}&modal=true']")
    end

    it "adds a related id to the has_many create team link" do
      @team = FactoryGirl.create :team
      visit edit_path(:model_name => "team", :id => @team.id)
      should have_selector("a[data-link='/admin/player/new?associations%5Bteam%5D=#{@team.id.to_s}&modal=true']")
    end
  end

  describe "readonly associations" do

    it "is not editable" do
      @league = FactoryGirl.create :league
      visit edit_path(:model_name => "league", :id => @league.id)
      should_not have_selector('select#league_team_ids')
      should have_selector('select#league_division_ids') # decoy, fails if naming scheme changes
    end
  end

  describe "edit with has-and-belongs-to-many association" do
    before(:each) do
      @teams = 3.times.map { FactoryGirl.create :team }
      @fan = FactoryGirl.create :fan, :teams => [@teams[0]]
      visit edit_path(:model_name => "fan", :id => @fan.id)
    end

    it "shows associated objects" do
      should have_selector "#fan_team_ids" do |select|
        expect(select[0]).to have_selector 'option[selected="selected"]'
        expect(select[1]).not_to have_selector 'option[selected="selected"]'
        expect(select[2]).not_to have_selector 'option[selected="selected"]'
      end
    end
  end

  describe "edit with missing object" do
    before(:each) do
      visit edit_path(:model_name => "player", :id => 1)
    end

    it "raises NotFound" do
      expect(page.driver.status_code).to eq(404)
    end
  end

  describe "edit with missing label", :given => ["a player exists", "three teams with no name exist"] do
    before(:each) do
      @player = FactoryGirl.create :player
      @teams = 3.times.map { FactoryGirl.create :team, :name => "" }
      visit edit_path(:model_name => "player", :id => @player.id)
    end
  end

  describe "edit object with overridden to_param" do
    before(:each) do
      @ball = FactoryGirl.create :ball
      visit edit_path(:model_name => "ball", :id => @ball.id)
    end

    it "displays a link to the delete page" do
      should have_selector "a[href='/admin/ball/#{@ball.id}/delete']"
    end

  end

  describe "clicking cancel when editing an object" do

    it "sends back to previous URL" do
      @ball = FactoryGirl.create :ball
      visit '/admin/ball?sort=color'
      click_link 'Edit'
      click_button 'Cancel'
      expect(page.current_url).to eq('http://www.example.com/admin/ball?sort=color')
    end
  end
end
