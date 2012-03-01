require 'spec_helper'

describe "RailsAdmin Basic Edit" do

  subject { page }

  describe "edit" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit edit_path(:model_name => "player", :id => @player.id)
    end

    it "should show \"Edit model\"" do
      should have_content("Edit Player")
    end

    it "should show required fields as \"Required\"" do
      should have_selector("div", :text => /Name\s*Required/)
      should have_selector("div", :text => /Number\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      find("#player_position_field .help-block").should have_content("Optional")
      find("#player_born_on_field .help-block").should have_content("Optional")
      find("#player_notes_field .help-block").should have_content("Optional")
    end
  end

  describe "association with inverse_of option" do
    it "should add a related id to the belongs_to create team link" do
      @player = FactoryGirl.create :player
      visit edit_path(:model_name => "player", :id => @player.id)
      should have_selector("a", :href => 'admin/teams/new?associations[players]=' + @player.id.to_s)
    end

    it "should add a related id to the has_many create team link" do
      @team = FactoryGirl.create :team
      visit edit_path(:model_name => "team", :id => @team.id)
      should have_selector("a", :href => 'admin/players/new?associations[team]=' + @team.id.to_s)
    end
  end

  describe "readonly associations" do

    it 'should not be editable' do
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

    it "should show associated objects" do
      should have_selector "#fan_team_ids" do |select|
        select[0].should have_selector 'option[selected="selected"]'
        select[1].should_not have_selector 'option[selected="selected"]'
        select[2].should_not have_selector 'option[selected="selected"]'
      end
    end
  end

  describe "edit with missing object" do
    before(:each) do
      visit edit_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      page.driver.status_code.should eql(404)
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

    it "should display a link to the delete page" do
      should have_selector "a[href='/admin/ball/#{@ball.id}/delete']"
    end

  end

  describe "clicking cancel when editing an object" do

    it "should send back to previous URL" do
      @ball = FactoryGirl.create :ball
      visit '/admin/ball?sort=color'
      click_link 'Edit'
      click_button 'Cancel'
      page.current_url.should == 'http://www.example.com/admin/ball?sort=color'
    end
  end
end
