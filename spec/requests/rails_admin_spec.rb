require 'spec_helper'

describe "RailsAdmin" do

  subject { page }

  describe "authentication" do
    it "should be disableable" do
      logout
      RailsAdmin.config do |config|
        config.authenticate_with {}
      end
      visit rails_admin_dashboard_path
    end
  end

  # A common mistake for translators is to forget to change the YAML file's
  # root key from en to their own locale (as people tend to use the English
  # file as template for a new translation).
  describe "localization" do
    it "should default to English" do
      visit rails_admin_dashboard_path

      should have_content("Site administration")
      should have_content("Dashboard")
    end
  end

  describe "html head" do
    before { visit rails_admin_dashboard_path }

    # Note: the [href^="/sty... syntax matches the start of a value. The reason
    # we just do that is to avoid being confused by rails' asset_ids.
    it "should load stylesheets" do
      should have_selector('link[href^="/stylesheets/rails_admin/ra.timeline.css"]')
    end

    it "should load javascript files" do
      scripts = %w[ /javascripts/rails_admin/application.js
                //ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js
                //ajax.googleapis.com/ajax/libs/jqueryui/1.8.13/jquery-ui.min.js ]

      scripts.each do |script|
        should have_selector(%Q{script[src^="#{script}"]})
      end
    end
  end

  describe "polymorphic associations" do
    before :each do
      @team = FactoryGirl.create :team
      @comment = FactoryGirl.create :comment, :commentable => @team
    end

    it "should work like belongs to associations in the list view" do
      visit rails_admin_list_path(:model_name => "comment")

      should have_content(@team.name)
    end

    it "should be editable" do
      visit rails_admin_edit_path(:model_name => "comment", :id => @comment.id)

      should have_selector("legend", :text => "Commentable")
      should have_selector("select#comment_commentable_type")
      should have_selector("select#comment_commentable_id")
    end

    it "should be hidden in the owning end" do
      visit rails_admin_edit_path(:model_name => "team", :id => @team.id)

      should have_no_selector("legend", :text => "Comments")
    end
  end

  describe "model whitelist:" do

    it 'should only use included models' do
      RailsAdmin.config.included_models = [Team, League]
      RailsAdmin::AbstractModel.all.map(&:model).should == [League, Team] #it gets sorted
    end

    it 'should not restrict models if included_models is left empty' do
      RailsAdmin.config.included_models = []
      RailsAdmin::AbstractModel.all.map(&:model).should include(Team, League)
    end

    it 'should further remove excluded models (whitelist - blacklist)' do
      RailsAdmin.config.excluded_models = [Team]
      RailsAdmin.config.included_models = [Team, League]
      RailsAdmin::AbstractModel.all.map(&:model).should == [League]
    end

    it 'should always exclude history' do
      RailsAdmin::AbstractModel.all.map(&:model).should_not include(RailsAdmin::History)
    end

    it 'excluded? returns true for any model not on the list' do
      RailsAdmin.config.included_models = [Team, League]

      team_config = RailsAdmin.config(RailsAdmin::AbstractModel.new('Team'))
      fan_config = RailsAdmin.config(RailsAdmin::AbstractModel.new('Fan'))

      fan_config.should be_excluded
      team_config.should_not be_excluded
    end
  end
end
