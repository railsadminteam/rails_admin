require 'spec_helper'

describe "RailsAdmin" do

  describe "authentication" do
    it "should be disableable" do
      logout
      RailsAdmin.authenticate_with {}
      get rails_admin_dashboard_path
      response.should be_successful
    end
  end

  # A common mistake for translators is to forget to change the YAML file's
  # root key from en to their own locale (as people tend to use the English
  # file as template for a new translation).
  describe "localization" do
    it "should default to English" do
      get rails_admin_dashboard_path

      response.should contain("Site administration")
      response.should contain("Dashboard")
    end
  end

  describe "html head" do
    it "should include the required css and js files" do
      get rails_admin_dashboard_path
      
      response.should have_selector('link[href^="/stylesheets/rails_admin/ra.timeline.css"]')
      response.should have_selector('script[src^="/javascripts/rails_admin/application.js"]')
    end
  end

  describe "polymorphic associations" do
    before :each do
      @team = RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Commentable Team", :manager => "Manager", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @comment = RailsAdmin::AbstractModel.new("Comment").create(:content => "Comment on a team", :commentable => @team)
    end

    it "should work like belongs to associations in the list view" do
      get rails_admin_list_path(:model_name => "comment")

      response.body.should contain(@team.name)
    end

    it "should be editable" do
      get rails_admin_edit_path(:model_name => "comment", :id => @comment.id)

      response.should have_tag("legend", :content => "Commentable")
      response.should have_tag("select#comment_commentable_type")
      response.should have_tag("select#comment_commentable_id")
    end
  end
  
end