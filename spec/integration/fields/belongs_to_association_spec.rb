require 'spec_helper'

RSpec.describe 'BelongsToAssociation field', type: :request do
  subject { page }

  it 'does not add a related id to the belongs_to create team link' do
    @player = FactoryBot.create :player
    visit edit_path(model_name: 'player', id: @player.id)
    is_expected.to have_selector("a[data-link='/admin/team/new?modal=true']")
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
    let(:users) { FactoryBot.create_list :managing_user, 2 }
    let!(:teams) { [FactoryBot.create(:managed_team, manager: users[0].email), FactoryBot.create(:managed_team)] }
    before do
      RailsAdmin.config.included_models = [ManagedTeam, ManagingUser]
      RailsAdmin.config ManagedTeam do
        field :user
      end
    end

    it 'allows update' do
      visit edit_path(model_name: 'managed_team', id: teams[0].id)
      expect(page).to have_css("select#managed_team_manager option[value=\"#{users[0].email}\"]")
      select("ManagingUser ##{users[1].id}", from: 'User')
      click_button 'Save'
      teams[0].reload
      expect(teams[0].user).to eq users[1]
    end

    context 'when fetching associated objects via xhr' do
      before do
        RailsAdmin.config ManagedTeam do
          field(:user) { associated_collection_cache_all false }
        end
      end

      it 'allows update', js: true do
        visit edit_path(model_name: 'managed_team', id: teams[0].id)
        find('input.ra-filtering-select-input').set('M')
        page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
        expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item a')
        page.execute_script %{[...document.querySelectorAll('ul.ui-autocomplete li.ui-menu-item')].find(e => e.innerText.includes("ManagingUser ##{users[1].id}")).click()}
        click_button 'Save'
        teams[0].reload
        expect(teams[0].user).to eq users[1]
      end
    end
  end
end
