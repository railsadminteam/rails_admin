require 'spec_helper'

describe "RailsAdmin Basic Edit" do

  describe "edit" do
    before(:each) do
      @player = FactoryGirl.create :player
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show \"Update model\"" do
      response.body.should contain("Update player")
    end

    it "should show required fields as \"Required\"" do
      response.body.should contain(/Name\n\s*Required/)
      response.body.should contain(/Number\n\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      response.body.should have_tag(".player_position .help", :content => "Optional")
      response.body.should have_tag(".player_born_on .help", :content => "Optional")
      response.body.should have_tag(".player_notes .help", :content => "Optional")
    end
  end

  describe "edit with has-one association" do
    before(:each) do
      @player = FactoryGirl.create :player
      @draft = FactoryGirl.create :draft
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Draft #\d+/)
    end
  end

  describe "edit with has-many association" do
    before(:each) do
      @teams = 3.times.map { FactoryGirl.create :team }
      @player = FactoryGirl.create :player
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      @teams.each { |team| response.body.should contain(/#{team.name}/) }
    end
  end

  describe "edit with has-and-belongs-to-many association" do
    before(:each) do
      @teams = 3.times.map { FactoryGirl.create :team }
      @fan = FactoryGirl.create :fan, :teams => [@teams[0]]
      get rails_admin_edit_path(:model_name => "fan", :id => @fan.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should have_tag "#fan_team_ids" do |select|
        select[0].should have_selector 'option[selected="selected"]'
        select[1].should_not have_selector 'option[selected="selected"]'
        select[2].should_not have_selector 'option[selected="selected"]'
      end
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
      @player = FactoryGirl.create :player
      @teams = 3.times.map { FactoryGirl.create :team, :name => "" }
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond successfully" do
      response.should be_successful
    end
  end
end
