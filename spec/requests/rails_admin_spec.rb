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
    before { get rails_admin_dashboard_path }
    subject { response }

    # Note: the [href^="/sty... syntax matches the start of a value. The reason
    # we just do that is to avoid being confused by rails' asset_ids.
    it "should load stylesheets" do
      should have_selector('link[href^="/stylesheets/rails_admin/ra.timeline.css"]')
    end

    it "should load javascript files" do
      scripts = %w[ /javascripts/rails_admin/application.js
                http://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js
                http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.10/jquery-ui.min.js ]

      scripts.each do |script|
        should have_selector(%Q{script[src^="#{script}"]})
      end
    end
  end

  describe "polymorphic associations" do
    before :each do
      @team = Factory.create :team
      @comment = Factory.create :comment, :commentable => @team
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
