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
      @user = RailsAdmin::AbstractModel.new("User").create(:email => "tester@test.com", :password => "tester1234")
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

      it "GET /admin/player should render successfully but not list retired players" do
        pending "Rails Admin currently buries fetching logic into AbstractModel so it is difficult to have it dependent upon CanCan authorization rules. I think this should be restructured to work with scopes."
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Leonardo", :retired => false)
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Splinter", :retired => true)
        get rails_admin_list_path(:model_name => "player", :set => 1)
        response.code.should == "200"
        response.body.should contain(/Leonardo/)
        response.body.should_not contain(/Splinter/)
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
        fill_in "players[name]", :with => "Jackie Robinson"
        fill_in "players[number]", :with => "42"
        fill_in "players[position]", :with => "Second baseman"
        @req = click_button "Save"
        @player = RailsAdmin::AbstractModel.new("Player").first
        @req.should be_successful
        @player.name.should eql("Jackie Robinson")
        @player.number.should eql(42)
        @player.position.should eql("Second baseman")
        @player.should be_suspended # suspended is inherited behavior based on permission
      end

      it "GET /admin/player/1/edit should raise access denied" do
        @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
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
        @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
        get rails_admin_edit_path(:model_name => "player", :id => @player.id)
        fill_in "players[name]", :with => "Jackie Robinson"
        @req = click_button "Save"
        @player = RailsAdmin::AbstractModel.new("Player").first
        @req.should be_successful
        @player.name.should eql("Jackie Robinson")
      end

      it "GET /admin/player/1/edit with retired player should raise access denied" do
        @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1", :retired => true)
        lambda {
          get rails_admin_edit_path(:model_name => "player", :id => @player.id)
        }.should raise_error(CanCan::AccessDenied)
      end

      it "GET /admin/player/1/delete should raise access denied" do
        @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
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
        @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
        get rails_admin_delete_path(:model_name => "player", :id => @player.id)
        @req = click_button "Yes, I'm sure"
        @player = RailsAdmin::AbstractModel.new("Player").first
        @req.should be_successful
        @player.should be_nil
      end

      it "GET /admin/player/1/delete with retired player should raise access denied" do
        @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1", :retired => true)
        lambda {
          get rails_admin_delete_path(:model_name => "player", :id => @player.id)
        }.should raise_error(CanCan::AccessDenied)
      end

    end

    # TODO: Authorize bulk_delete and bulk_destroy actions
    # TODO: Figure out best way to handle authorization in index action, maybe with `can :access, :rails_admin` permission check on every action
  end

end
