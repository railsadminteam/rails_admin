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
      get rails_admin_list_path(:model_name => "comment")

      response.body.should contain(@team.name)
    end

    it "should be editable" do
      get rails_admin_edit_path(:model_name => "comment", :id => @comment.id)

      response.should have_tag("legend", :content => "Commentable")
      response.should have_tag("select#comment_commentable_type")
      response.should have_tag("select#comment_commentable_id")
    end

    it "should be hidden in the owning end" do
      get rails_admin_edit_path(:model_name => "team", :id => @team.id)

      response.should_not have_tag("legend", :content => "Comments")
    end
  end

  describe "model whitelist:" do

    before do
      RailsAdmin::AbstractModel.instance_variable_get("@models").clear
      RailsAdmin::Config.excluded_models = []
      RailsAdmin::Config.included_models = []
      RailsAdmin::Config.reset
    end

    after :all do
      RailsAdmin::AbstractModel.instance_variable_get("@models").clear
      RailsAdmin::Config.excluded_models = []
      RailsAdmin::Config.included_models = []
      RailsAdmin::Config.reset
    end

    it 'should only use included models' do
      RailsAdmin::Config.included_models = [Team, League]
      RailsAdmin::AbstractModel.all.map(&:model).should == [League, Team] #it gets sorted
    end

    it 'should not restrict models if included_models is left empty' do
      RailsAdmin::Config.included_models = []
      RailsAdmin::AbstractModel.all.map(&:model).should include(Team, League)
    end

    it 'should further remove excluded models (whitelist - blacklist)' do
      RailsAdmin::Config.excluded_models = [Team]
      RailsAdmin::Config.included_models = [Team, League]
      RailsAdmin::AbstractModel.all.map(&:model).should == [League]
    end

    it 'should always exclude history' do
      RailsAdmin::AbstractModel.all.map(&:model).should_not include(RailsAdmin::History)
    end

    it 'excluded? returns true for any model not on the list' do
      RailsAdmin::Config.included_models = [Team, League]

      team_config = RailsAdmin.config(RailsAdmin::AbstractModel.new('Team'))
      fan_config = RailsAdmin.config(RailsAdmin::AbstractModel.new('Fan'))

      fan_config.should be_excluded
      team_config.should_not be_excluded
    end
    
  end

end
