require 'spec_helper'

describe "RailsAdmin Basic New" do

  describe "GET /admin/player/new" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show \"Create model\"" do
      response.body.should contain("Create player")
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

  describe "GET /admin/player/new with has-one association" do
    before(:each) do
      Factory.create :draft
      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Draft #\d+/)
    end
  end

  describe "GET /admin/player/new with has-many association" do
    before(:each) do
      @teams = 3.times.map { Factory.create :team }
      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      @teams.each do |team|
        response.body.should contain(/#{team.name}/)
      end
    end
  end

  describe "GET /admin/team/:id/fans/new with has-and-belongs-to-many association" do
    before(:each) do
      @teams = 3.times.map { Factory.create :team }
      get rails_admin_new_path(:model_name => "fan")
    end

    it "should respond successfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      @teams.each do |team|
        response.body.should contain(/#{team.name}/)
      end
    end
  end

  describe "GET /admin/player/new with missing label" do
    before(:each) do
      Factory.create :team, :name => ""
      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond successfully" do
      response.should be_successful
    end
  end
end
