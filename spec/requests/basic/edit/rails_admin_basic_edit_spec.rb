require 'spec_helper'

describe "RailsAdmin Basic Edit" do

  subject { page }

  describe "edit" do
    before(:each) do
      @player = FactoryGirl.create :player
      visit rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should show \"Update model\"" do
      should have_content("Update player")
    end

    it "should show required fields as \"Required\"" do
      should have_selector("div", :text => /Name\s*Required/)
      should have_selector("div", :text => /Number\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      should have_selector(".player_position .help", :text => "Optional")
      should have_selector(".player_born_on .help", :text => "Optional")
      should have_selector(".player_notes .help", :text => "Optional")
    end
  end

  describe "edit with has-one association" do
    before(:each) do
      @player = FactoryGirl.create :player
      @draft = FactoryGirl.create :draft
      visit rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should show associated objects" do
      should have_selector("option", :text => /Draft #\d+/)
    end
  end

  describe "edit with has-many association" do
    before(:each) do
      @teams = 3.times.map { FactoryGirl.create :team }
      @player = FactoryGirl.create :player
      visit rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should show associated objects" do
      @teams.each { |team| should have_selector("option", :text => /#{team.name}/) }
    end
  end

  describe "edit with has-and-belongs-to-many association" do
    before(:each) do
      @teams = 3.times.map { FactoryGirl.create :team }
      @fan = FactoryGirl.create :fan, :teams => [@teams[0]]
      visit rails_admin_edit_path(:model_name => "fan", :id => @fan.id)
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
      visit rails_admin_edit_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      page.driver.status_code.should eql(404)
    end
  end

  describe "edit with missing label", :given => ["a player exists", "three teams with no name exist"] do
    before(:each) do
      @player = FactoryGirl.create :player
      @teams = 3.times.map { FactoryGirl.create :team, :name => "" }
      visit rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end
  end
end
