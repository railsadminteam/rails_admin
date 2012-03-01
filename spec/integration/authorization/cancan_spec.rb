require 'spec_helper'

class Ability
  include CanCan::Ability
  def initialize(user)
    can :access, :rails_admin if user.roles.include? :admin
    unless user.roles.include? :test_exception
      can :dashboard
      can :manage, Player if user.roles.include? :manage_player
      can :read, Player, :retired => false if user.roles.include? :read_player
      can :create, Player, :suspended => true if user.roles.include? :create_player
      can :update, Player, :retired => false if user.roles.include? :update_player
      can :destroy, Player, :retired => false if user.roles.include? :destroy_player
      can :history, Player, :retired => false if user.roles.include? :history_player
      can :show_in_app, Player, :retired => false if user.roles.include? :show_in_app_player
    else
      can :dashboard
      can :access, :rails_admin
      can :manage, :all
      can :show_in_app, :all
      cannot [:update, :destroy], Player, :retired => true
    end
  end
end

class AdminAbility
  include CanCan::Ability
  def initialize(user)
    can :access, :rails_admin if user.roles.include? :admin
    can :show_in_app, :all
    can :manage, :all
  end
end

describe "RailsAdmin CanCan Authorization" do

  subject { page }

  before(:each) do
    RailsAdmin.config{|c| c.authorize_with(:cancan); c.audit_with(:history, User) }
    @user = FactoryGirl.create :user
    login_as @user
  end

  describe "with no roles" do
    before(:each) do
      @user.update_attribute(:roles, [])
    end

    it "GET /admin should raise CanCan::AccessDenied" do
      visit dashboard_path
      should have_content('CanCan::AccessDenied')
    end

    it "GET /admin/player should raise CanCan::AccessDenied" do
      visit index_path(:model_name => "player")
      should have_content('CanCan::AccessDenied')
    end
  end

  describe "with read player role" do
    before(:each) do
      @user.update_attribute(:roles, [:admin, :read_player])
    end

    it "GET /admin should show Player but not League" do
      visit dashboard_path
      body.should have_content("Player")
      body.should_not have_content("League")
      body.should_not have_content("Add new")
    end

    it "GET /admin/player should render successfully but not list retired players and not show new, edit, or delete actions" do
      @players = [
        FactoryGirl.create(:player, :retired => false),
        FactoryGirl.create(:player, :retired => true),
      ]

      visit index_path(:model_name => "player")

      should have_content(@players[0].name)
      should_not have_content(@players[1].name)
      should_not have_content("Add new")
      should have_css('.show_member_link')
      should_not have_css('.edit_member_link')
      should_not have_css('.delete_member_link')
      should_not have_css('.history_show_member_link')
      should_not have_css('.show_in_app_member_link')
    end

    it "GET /admin/team should raise CanCan::AccessDenied" do
      visit index_path(:model_name => "team")
      should have_content('CanCan::AccessDenied')
    end

    it "GET /admin/player/new should raise CanCan::AccessDenied" do
      visit new_path(:model_name => "player")
      should have_content('CanCan::AccessDenied')
    end

  end

  describe "with create and read player role" do
    before(:each) do
      @user.update_attribute(:roles, [:admin, :read_player, :create_player])
    end

    it "GET /admin/player/new should render and create record upon submission" do
      visit new_path(:model_name => "player")

      should_not have_content("Save and edit")
      should_not have_content("Delete")

      should have_content("Save and add another")
      fill_in "player[name]", :with   => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      click_button "Save"
      should_not have_content("Edit")

      @player = RailsAdmin::AbstractModel.new("Player").first
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
      @player.should be_suspended # suspended is inherited behavior based on permission
    end

    it "GET /admin/player/1/edit should raise access denied" do
      @player = FactoryGirl.create :player
      visit edit_path(:model_name => "player", :id => @player.id)
      should have_content('CanCan::AccessDenied')
    end

  end

  describe "with update and read player role" do
    before(:each) do
      @user.update_attribute(:roles, [:admin, :read_player, :update_player])
    end

    it "GET /admin/player/1/edit should render and update record upon submission" do
      @player = FactoryGirl.create :player
      visit edit_path(:model_name => "player", :id => @player.id)
      should have_content("Save and edit")
      should_not have_content("Save and add another")
      should_not have_content("Add new")
      should_not have_content("Delete")
      should_not have_content("History")
      should_not have_content("Show in app")
      fill_in "player[name]", :with => "Jackie Robinson"
      click_button "Save"
      @player.reload
      @player.name.should eql("Jackie Robinson")
    end

    it "GET /admin/player/1/edit with retired player should raise access denied" do
      @player = FactoryGirl.create :player, :retired => true
      visit edit_path(:model_name => "player", :id => @player.id)
      should have_content('CanCan::AccessDenied')
    end

    it "GET /admin/player/1/delete should raise access denied" do
      @player = FactoryGirl.create :player
      visit delete_path(:model_name => "player", :id => @player.id)
      should have_content('CanCan::AccessDenied')
    end

  end

  describe "with history role" do
    it 'shows links to history action' do

      @user.update_attribute(:roles, [:admin, :read_player, :history_player])
      @player = FactoryGirl.create :player

      visit index_path(:model_name => "player")
        should have_css('.show_member_link')
        should_not have_css('.edit_member_link')
        should_not have_css('.delete_member_link')
        should have_css('.history_show_member_link')

      visit show_path(:model_name => 'player', :id => @player.id)
        should have_content("Show")
        should_not have_content("Edit")
        should_not have_content("Delete")
        should have_content("History")

    end
  end

  describe "with show in app role" do
    it 'shows links to show in app action' do

      @user.update_attribute(:roles, [:admin, :read_player, :show_in_app_player])
      @player = FactoryGirl.create :player

      visit index_path(:model_name => "player")
        should have_css('.show_member_link')
        should_not have_css('.edit_member_link')
        should_not have_css('.delete_member_link')
        should_not have_css('.history_show_member_link')
        should have_css('.show_in_app_member_link')

      visit show_path(:model_name => 'player', :id => @player.id)
        should have_content("Show")
        should_not have_content("Edit")
        should_not have_content("Delete")
        should_not have_content("History")
        should have_content("Show in app")

    end
  end

  describe "with all roles" do
    it 'shows links to all actions' do

      @user.update_attribute(:roles, [:admin, :manage_player])
      @player = FactoryGirl.create :player

      visit index_path(:model_name => "player")
        should have_css('.show_member_link')
        should have_css('.edit_member_link')
        should have_css('.delete_member_link')
        should have_css('.history_show_member_link')
        should have_css('.show_in_app_member_link')

      visit show_path(:model_name => 'player', :id => @player.id)
        should have_content("Show")
        should have_content("Edit")
        should have_content("Delete")
        should have_content("History")
        should have_content("Show in app")

    end
  end

  describe "with destroy and read player role" do
    before(:each) do
      @user.update_attribute(:roles, [:admin, :read_player, :destroy_player])
    end

    it "GET /admin/player/1/delete should render and destroy record upon submission" do
      @player = FactoryGirl.create :player
      player_id = @player.id
      visit delete_path(:model_name => "player", :id => player_id)

      click_button "Yes, I'm sure"

      Player.exists?(player_id).should be_false
    end

    it "GET /admin/player/1/delete with retired player should raise access denied" do
      @player = FactoryGirl.create :player, :retired => true
      visit delete_path(:model_name => "player", :id => @player.id)
      should have_content('CanCan::AccessDenied')
    end

    it "GET /admin/player/bulk_delete should render records which are authorized to" do
      active_player = FactoryGirl.create :player, :retired => false
      retired_player = FactoryGirl.create :player, :retired => true

      page.driver.post(bulk_action_path(:bulk_action => 'bulk_delete', :model_name => "player", :bulk_ids => [active_player, retired_player].map(&:id)))

      should have_content(active_player.name)
      should_not have_content(retired_player.name)
    end

    it "POST /admin/player/bulk_destroy should destroy records which are authorized to" do
      active_player = FactoryGirl.create :player, :retired => false
      retired_player = FactoryGirl.create :player, :retired => true

      page.driver.delete(bulk_delete_path(:model_name => "player", :bulk_ids => [active_player, retired_player].map(&:id)))
      Player.exists?(active_player.id).should be_false
      Player.exists?(retired_player.id).should be_true
    end
  end

  describe "with exception role" do
    it "GET /admin/player/bulk_delete should render records which are authorized to" do
      @user.update_attribute(:roles, [:admin, :test_exception])
      active_player = FactoryGirl.create :player, :retired => false
      retired_player = FactoryGirl.create :player, :retired => true

      page.driver.post(bulk_action_path(:bulk_action => 'bulk_delete', :model_name => "player", :bulk_ids => [active_player, retired_player].map(&:id)))

      should have_content(active_player.name)
      should_not have_content(retired_player.name)
    end

    it "POST /admin/player/bulk_destroy should destroy records which are authorized to" do
      @user.update_attribute(:roles, [:admin, :test_exception])
      active_player = FactoryGirl.create :player, :retired => false
      retired_player = FactoryGirl.create :player, :retired => true

      page.driver.delete(bulk_delete_path(:model_name => "player", :bulk_ids => [active_player, retired_player].map(&:id)))
      Player.exists?(active_player.id).should be_false
      Player.exists?(retired_player.id).should be_true
    end
  end

  describe "with a custom admin ability" do
    before(:each) do
      RailsAdmin.config{|c| c.authorize_with :cancan, AdminAbility }
      @user = FactoryGirl.create :user
      login_as @user
    end

    describe "with admin role only" do
      before(:each) do
        @user.update_attribute(:roles, [:admin])
      end

      it "GET /admin/team should render successfully" do
        visit index_path(:model_name => "team")
        page.status_code.should == 200
      end

      it "GET /admin/player/new should render successfully" do
        visit new_path(:model_name => "player")
        page.status_code.should == 200
      end

      it "GET /admin/player/1/edit should render successfully" do
        @player = FactoryGirl.create :player
        visit edit_path(:model_name => "player", :id => @player.id)
        page.status_code.should == 200
      end

      it "GET /admin/player/1/edit with retired player should render successfully" do
        @player = FactoryGirl.create :player, :retired => true
        visit edit_path(:model_name => "player", :id => @player.id)
        page.status_code.should == 200
      end

      it "GET /admin/player/1/delete should render successfully" do
        @player = FactoryGirl.create :player
        visit delete_path(:model_name => "player", :id => @player.id)
        page.status_code.should == 200
      end

      it "GET /admin/player/1/delete with retired player should render successfully" do
        @player = FactoryGirl.create :player, :retired => true
        visit delete_path(:model_name => "player", :id => @player.id)
        page.status_code.should == 200
      end
    end
  end

end
