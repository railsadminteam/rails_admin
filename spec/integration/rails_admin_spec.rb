require 'spec_helper'

describe "RailsAdmin" do

  subject { page }

  describe "authentication" do
    it "should be disableable" do
      logout
      RailsAdmin.config do |config|
        config.authenticate_with {}
      end
      visit dashboard_path
    end
  end

  # A common mistake for translators is to forget to change the YAML file's
  # root key from en to their own locale (as people tend to use the English
  # file as template for a new translation).
  describe "localization" do
    it "should default to English" do
      visit dashboard_path

      should have_content("Site administration")
      should have_content("Dashboard")
    end
  end

  describe "html head" do
    before { visit dashboard_path }

    # Note: the [href^="/asset... syntax matches the start of a value. The reason
    # we just do that is to avoid being confused by rails' asset_ids.
    it "should load stylesheets in header" do
      should have_selector('head link[href^="/assets/rails_admin/rails_admin.css"]')
    end

    it "should load javascript files in body" do
      should have_selector('head script[src^="/assets/rails_admin/rails_admin.js"]')
    end
  end

  describe 'hidden fields with default values' do
    it "should show up with default value, hidden" do
      RailsAdmin.config Player do
        include_all_fields
        edit do
          field :name, :hidden do
            default_value do
              bindings[:view]._current_user.email
            end
          end
        end
      end

      visit new_path(:model_name => "player")
      should have_selector("#player_name[type=hidden][value='username@example.com']")
      should_not have_selector("#player_name[type=hidden][value='toto@example.com']")
    end
  end

  describe '_current_user' do # https://github.com/sferik/rails_admin/issues/549

    it 'should be accessible from the list view' do
      RailsAdmin.config Player do
        list do
          field :name do
            visible do
              bindings[:view]._current_user.email == 'username@example.com'
            end
          end

          field :team do
            visible do
              bindings[:view]._current_user.email == 'foo@example.com'
            end
          end
        end
      end

      visit index_path(:model_name => "player")
      should have_selector(".header.name_field")
      should_not have_selector(".header.team_field")
    end
  end

  describe "polymorphic associations" do
    before :each do
      @team = FactoryGirl.create :team
      @comment = FactoryGirl.create :comment, :commentable => @team
    end

    it "should work like belongs to associations in the list view" do
      visit index_path(:model_name => "comment")

      should have_content(@team.name)
    end

    it "should be editable" do
      visit edit_path(:model_name => "comment", :id => @comment.id)

      should have_selector("select#comment_commentable_type")
      should have_selector("select#comment_commentable_id")
    end

    it "should be visible in the owning end" do
      visit edit_path(:model_name => "team", :id => @team.id)

      should have_selector("select#team_comment_ids")
    end
  end

end
