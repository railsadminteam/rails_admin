require 'spec_helper'

describe "RailsAdmin Basic New" do

  subject { page }

  describe "GET /admin/player/new" do
    before(:each) do
      visit new_path(:model_name => "player")
    end

    it "shows \"New Model\"" do
      should have_content("New Player")
    end

    it "shows required fields as \"Required\"" do
      should have_selector("div", :text => /Name\s*Required/)
      should have_selector("div", :text => /Number\s*Required/)
    end

    it "shows non-required fields as \"Optional\"" do
      should have_selector("#player_position_field .help-block", :text => "Optional")
      should have_selector("#player_born_on_field .help-block", :text => "Optional")
      should have_selector("#player_notes_field .help-block", :text => "Optional")
    end

    # https://github.com/sferik/rails_admin/issues/362
    # test that no link uses the "wildcard route" with the main
    # controller and new method
    it "does not use the 'wildcard route'" do
      should have_no_selector("a[href^='/rails_admin/main/new']")
    end
  end

  describe "GET /admin/player/new with has-one/belongs_to/has_many association" do
    before(:each) do
      FactoryGirl.create :draft
      visit new_path(:model_name => "player")
    end

    it "shows selects" do
      should have_selector("select#player_draft_id")
      should have_selector("select#player_team_id")
      should have_selector("select#player_comment_ids")
    end
  end

  describe "GET /admin/player/new with missing label" do
    before(:each) do
      FactoryGirl.create :team, :name => ""
      visit new_path(:model_name => "player")
    end
  end

  describe "GET /admin/player/new with parameters for pre-population" do
    it "populates form field when corresponding parameters are passed in" do
      visit new_path(:model_name => 'player', :player => {:name => 'Sam'})
      expect(page).to have_css('input[value=Sam]')
    end

    it "prepropulates belongs to relationships" do
      @team = FactoryGirl.create :team, :name => "belongs_to association prepopulated"
      visit new_path(:model_name => 'player', :associations => { :team => @team.id } )
      expect(page).to have_css("select#player_team_id option[selected='selected'][value='#{@team.id}']")
    end

    it "prepropulates has_many relationships" do
      @player = FactoryGirl.create :player, :name => "has_many association prepopulated"
      visit new_path(:model_name => 'team', :associations => { :players => @player.id } )
      expect(page).to have_css("select#team_player_ids option[selected='selected'][value='#{@player.id}']")
    end
  end
end
