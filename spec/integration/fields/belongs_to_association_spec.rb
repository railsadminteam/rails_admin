require 'spec_helper'

describe 'BelongsToAssociation field', type: :request do
  subject { page }

  describe 'with inverse_of option' do
    it 'adds a related id to the belongs_to create team link' do
      @player = FactoryBot.create :player
      visit edit_path(model_name: 'player', id: @player.id)
      is_expected.to have_selector("a[data-link='/admin/team/new?associations%5Bplayers%5D=#{@player.id}&modal=true']")
    end

    it 'adds a related id to the has_many create team link' do
      @team = FactoryBot.create :team
      visit edit_path(model_name: 'team', id: @team.id)
      is_expected.to have_selector("a[data-link='/admin/player/new?associations%5Bteam%5D=#{@team.id}&modal=true']")
    end
  end

  describe 'on create' do
    before do
      FactoryBot.create :draft
      visit new_path(model_name: 'player')
    end

    it 'shows selects' do
      is_expected.to have_selector('select#player_team_id')
    end
  end

  describe 'on show' do
    before do
      @player = FactoryBot.create :player
      @team   = FactoryBot.create :team
      @player.update(team_id: @team.id)
      visit show_path(model_name: 'player', id: @player.id)
    end

    it 'shows associated objects' do
      is_expected.to have_css("a[href='/admin/team/#{@team.id}']")
    end
  end

  context 'with custom primary_key option' do
    let(:user) { FactoryBot.create :managing_user }
    let!(:teams) { [FactoryBot.create(:managed_team, manager: user.email), FactoryBot.create(:managed_team)] }
    before do
      RailsAdmin.config.included_models = [ManagedTeam]
      RailsAdmin.config ManagedTeam do
        field :user
      end
    end

    it 'picks up associated primary key correctly' do
      visit edit_path(model_name: 'managed_team', id: teams[0].id)
      expect(page).to have_css("select#managed_team_manager option[value=\"#{user.id}\"]")
    end
  end
end
