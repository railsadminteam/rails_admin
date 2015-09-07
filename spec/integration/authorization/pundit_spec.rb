require 'spec_helper'

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def new?
    user.roles.include? :admin
  end

  def show?
    true
  end

  def update?
    user.roles.include? :admin
  end

  def create?
    user.roles.include? :admin
  end

  def edit?
    user.roles.include? :admin
  end

  def destroy?
    user.roles.include? :admin
  end

  def rails_admin?(action)
    case action
    when :dashboard
      user.roles.include? :admin
    when :index
      false
    when :show
      user.roles.include? :admin
    when :new
      user.roles.include? :admin
    when :edit
      user.roles.include? :admin
    when :destroy
      false
    when :export
      user.roles.include? :admin
    when :history
      user.roles.include? :admin
    when :show_in_app
      user.roles.include? :admin
    else
      fail ::Pundit::NotDefinedError.new("unable to find policy #{action} for #{record}.")
    end
  end
end

class PlayerPolicy < ApplicationPolicy
  def rails_admin?(action)
    case action
    when :index
      user.roles.include? :admin
    when :show
      true
    when :new
      (user.roles.include?(:create_player) || user.roles.include?(:admin) || user.roles.include?(:manage_player))
    when :edit
      (user.roles.include? :manage_player)
    when :destroy
      (user.roles.include? :manage_player)
    when :export
      user.roles.include? :admin
    when :history
      user.roles.include? :admin
    when :show_in_app
      (user.roles.include?(:admin) || user.roles.include?(:manage_player))
    else
      fail ::Pundit::NotDefinedError.new("unable to find policy #{action} for #{record}.")
    end
  end
end

describe PlayerPolicy do
  before do
    RailsAdmin.config do |c|
      c.authorize_with(:pundit)
      c.authenticate_with { warden.authenticate! scope: :user }
      c.current_user_method(&:current_user)
    end
    @user = FactoryGirl.create :user
    @player_model = RailsAdmin::AbstractModel.new(Player)
    login_as @user
  end

  subject { PlayerPolicy.new(user, player) }

  let(:player) { @player_model }

  describe 'for a user with no roles' do
    let(:user) { @user }

    it { should permit(:show)    }
    it { should_not permit(:create)  }
    it { should_not permit(:new)     }
    it { should_not permit(:update)  }
    it { should_not permit(:edit)    }
    it { should_not permit(:destroy) }
  end

  describe 'for an admin' do
    before do
      @user.update_attributes(roles: [:admin, :read_player])
    end

    let(:user) { @user }
    it { should permit(:show)    }
    it { should permit(:create)  }
    it { should permit(:new)     }
    it { should permit(:update)  }
    it { should permit(:edit)    }
    it { should permit(:destroy) }
  end
end

describe 'RailsAdmin Pundit Authorization', type: :request do
  subject { page }

  before do
    RailsAdmin.config do |c|
      c.authorize_with(:pundit)
      c.authenticate_with { warden.authenticate! scope: :user }
      c.current_user_method(&:current_user)
    end
    @player_model = RailsAdmin::AbstractModel.new(Player)
    @user = FactoryGirl.create :user
    login_as @user
  end

  describe 'with no roles' do
    before do
      @user.update_attributes(roles: [])
    end

    it 'GET /admin should raise Pundit::NotAuthorizedError' do
      expect { visit dashboard_path }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'GET /admin/player should raise Pundit::NotAuthorizedError' do
      expect { visit index_path(model_name: 'player') }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe 'with read player role' do
    before do
      @user.update_attributes(roles: [:admin, :read_player])
    end

    it 'GET /admin should show Player but not League' do
      visit dashboard_path
      is_expected.to have_content('Player')
      is_expected.not_to have_content('League')
      is_expected.not_to have_content('Add new')
    end

    it 'GET /admin/team should raise Pundit::NotAuthorizedError' do
      expect { visit index_path(model_name: 'team') }.to raise_error(Pundit::NotAuthorizedError)
    end

    it 'GET /admin/player/1/edit should raise access denied' do
      @player = FactoryGirl.create :player
      expect { visit edit_path(model_name: 'player', id: @player.id) }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  describe 'with admin role' do
    before do
      @user.update_attributes(roles: [:admin, :manage_player])
    end

    it 'GET /admin should show Player but not League' do
      visit dashboard_path
      is_expected.to have_content('Player')
    end

    it 'GET /admin/player/new should render and create record upon submission' do
      visit new_path(model_name: 'player')

      is_expected.to have_content('Save and edit')
      is_expected.not_to have_content('Delete')

      is_expected.to have_content('Save and add another')
      fill_in 'player[name]', with: 'Jackie Robinson'
      fill_in 'player[number]', with: '42'
      fill_in 'player[position]', with: 'Second baseman'
      click_button 'Save' # first(:button, "Save").click
      is_expected.not_to have_content('Edit')

      @player = RailsAdmin::AbstractModel.new('Player').first
      expect(@player.name).to eq('Jackie Robinson')
      expect(@player.number).to eq(42)
      expect(@player.position).to eq('Second baseman')
    end
  end

  describe 'with all roles' do
    it 'shows links to all actions' do
      @user.update_attributes(roles: [:admin, :manage_player])
      @player = FactoryGirl.create :player

      visit index_path(model_name: 'player')
      is_expected.to have_css('.show_member_link')
      is_expected.to have_css('.edit_member_link')
      is_expected.to have_css('.delete_member_link')
      is_expected.to have_css('.history_show_member_link')
      is_expected.to have_css('.show_in_app_member_link')

      visit show_path(model_name: 'player', id: @player.id)
      is_expected.to have_content('Show')
      is_expected.to have_content('Edit')
      is_expected.to have_content('Delete')
      is_expected.to have_content('History')
      is_expected.to have_content('Show in app')
    end
  end
end
