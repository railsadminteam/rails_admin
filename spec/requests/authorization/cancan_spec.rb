# To run these specs, you need to pass AUTHORIZATION_ADAPTER=cancan environment variable. For example.
#
#   AUTHORIZATION_ADAPTER=cancan bundle
#   AUTHORIZATION_ADAPTER=cancan rake
#
if ENV["AUTHORIZATION_ADAPTER"] == "cancan"
  require 'spec_helper'

  class Ability
    include CanCan::Ability
    def initialize(user)
      can :access, :rails_admin if user.roles.include? :admin
      can :read, Player, :retired => false if user.roles.include? :read_player
      can :create, Player, :suspended => true if user.roles.include? :create_player
      can :update, Player, :retired => false if user.roles.include? :update_player
      can :destroy, Player, :retired => false if user.roles.include? :destroy_player
    end
  end

  describe "RailsAdmin CanCan Authorization" do
    before(:each) do
      RailsAdmin.authorize_with :cancan
      @user = FactoryGirl.create :user
      login_as @user
    end

    describe "with no roles" do
      before(:each) do
        @user.update_attribute(:roles, [])
      end

      it "GET /admin should raise CanCan::AccessDenied" do
        lambda {
          get rails_admin_dashboard_path
        }.should raise_error(CanCan::AccessDenied)
      end

      it "GET /admin/player should raise CanCan::AccessDenied" do
        lambda {
          get rails_admin_list_path(:model_name => "player")
        }.should raise_error(CanCan::AccessDenied)
      end

    end

    describe "with read player role" do
      before(:each) do
        @user.update_attribute(:roles, [:admin, :read_player])
      end

      it "GET /admin should show Player but not League" do
        get rails_admin_dashboard_path
        response.should be_successful
        response.body.should contain("Player")
        response.body.should_not contain("League")
        response.body.should_not contain("Add new")
      end

      it "GET /admin/player should render successfully but not list retired players and not show new, edit, or delete actions" do
        @players = [
          FactoryGirl.create(:player, :retired => false),
          FactoryGirl.create(:player, :retired => true),
        ]

        get rails_admin_list_path(:model_name => "player", :set => 1)

        response.should be_successful
        response.body.should contain(@players[0].name)
        response.body.should_not contain(@players[1].name)
        response.body.should_not contain("Add new")
        response.body.should_not contain("EDIT")
        response.body.should_not contain("DELETE")
        response.body.should_not contain("Edit")
        response.body.should_not contain("Delete")
      end

      it "GET /admin/team should raise CanCan::AccessDenied" do
        lambda {
          get rails_admin_list_path(:model_name => "team")
        }.should raise_error(CanCan::AccessDenied)
      end

      it "GET /admin/player/new should raise CanCan::AccessDenied" do
        lambda {
          get rails_admin_new_path(:model_name => "player")
        }.should raise_error(CanCan::AccessDenied)
      end

    end

    describe "with create and read player role" do
      before(:each) do
        @user.update_attribute(:roles, [:admin, :read_player, :create_player])
      end

      it "GET /admin/player/new should render and create record upon submission" do
        get rails_admin_new_path(:model_name => "player")
        response.body.should_not contain("edit")
        fill_in "player[name]", :with => "Jackie Robinson"
        fill_in "player[number]", :with => "42"
        fill_in "player[position]", :with => "Second baseman"
        @req = click_button "Save"
        @player = RailsAdmin::AbstractModel.new("Player").first
        @req.should be_successful
        @player.name.should eql("Jackie Robinson")
        @player.number.should eql(42)
        @player.position.should eql("Second baseman")
        @player.should be_suspended # suspended is inherited behavior based on permission
      end

      it "GET /admin/player/1/edit should raise access denied" do
        @player = FactoryGirl.create :player
        lambda {
          get rails_admin_edit_path(:model_name => "player", :id => @player.id)
        }.should raise_error(CanCan::AccessDenied)
      end

    end

    describe "with update and read player role" do
      before(:each) do
        @user.update_attribute(:roles, [:admin, :read_player, :update_player])
      end

      it "GET /admin/player/1/edit should render and update record upon submission" do
        @player = FactoryGirl.create :player
        get rails_admin_edit_path(:model_name => "player", :id => @player.id)
        response.body.should_not contain("Delete")
        fill_in "player[name]", :with => "Jackie Robinson"
        click_button "Save"
        @player.reload
        response.should be_successful
        @player.name.should eql("Jackie Robinson")
      end

      it "GET /admin/player/1/edit with retired player should raise access denied" do
        @player = FactoryGirl.create :player, :retired => true
        lambda {
          get rails_admin_edit_path(:model_name => "player", :id => @player.id)
        }.should raise_error(CanCan::AccessDenied)
      end

      it "GET /admin/player/1/delete should raise access denied" do
        @player = FactoryGirl.create :player
        lambda {
          get rails_admin_delete_path(:model_name => "player", :id => @player.id)
        }.should raise_error(CanCan::AccessDenied)
      end

    end

    describe "with destroy and read player role" do
      before(:each) do
        @user.update_attribute(:roles, [:admin, :read_player, :destroy_player])
      end

      it "GET /admin/player/1/delete should render and destroy record upon submission" do
        @player = FactoryGirl.create :player
        player_id = @player.id
        get rails_admin_delete_path(:model_name => "player", :id => player_id)

        click_button "Yes, I'm sure"
        response.should be_successful
        Player.exists?(player_id).should be_false
      end

      it "GET /admin/player/1/delete with retired player should raise access denied" do
        @player = FactoryGirl.create :player, :retired => true
        lambda {
          get rails_admin_delete_path(:model_name => "player", :id => @player.id)
        }.should raise_error(CanCan::AccessDenied)
      end

      it "GET /admin/player/bulk_delete should render and destroy records which are authorized to" do
        active_player = FactoryGirl.create :player, :retired => false
        retired_player = FactoryGirl.create :player, :retired => true

        @delete_ids = [active_player, retired_player].map(&:id)
        get rails_admin_bulk_delete_path(:model_name => "player", :bulk_ids => @delete_ids)

        response.body.should contain(active_player.name)
        response.body.should_not contain(retired_player.name)
        click_button "Yes, I'm sure"

        Player.exists?(active_player.id).should be_false
        Player.exists?(retired_player.id).should be_true
      end

    end
  end

end
