

require 'spec_helper'

RSpec.describe 'HasOneAssociation field', type: :request do
  subject { page }

  it 'adds a related id to the has_one create draft link' do
    @player = FactoryBot.create :player
    visit edit_path(model_name: 'player', id: @player.id)
    is_expected.to have_selector("a[data-link='/admin/draft/new?draft%5Bplayer_id%5D=#{@player.id}&modal=true']")
  end

  context 'on create' do
    before do
      @draft = FactoryBot.create :draft
      visit new_path(model_name: 'player')
    end

    it 'shows selects' do
      is_expected.to have_selector('select#player_draft_id')
    end

    it 'creates an object with correct associations' do
      fill_in 'Name', with: 'Jackie Robinson'
      fill_in 'Number', with: @draft.player.number + 1
      select("Draft ##{@draft.id}", from: 'Draft')
      click_button 'Save'
      is_expected.to have_content 'Player successfully created'
      @player = Player.where(name: 'Jackie Robinson').first
      @draft.reload
      expect(@player.draft).to eq(@draft)
    end
  end

  context 'on update' do
    before do
      @drafts = FactoryBot.create_list :draft, 2
      @player = FactoryBot.create :player, draft: @drafts[0]
      visit edit_path(model_name: 'player', id: @player.id)
    end

    it 'updates an object with correct associations' do
      select("Draft ##{@drafts[1].id}", from: 'Draft')
      click_button 'Save'
      @player.reload
      expect(@player.draft).to eq(@drafts[1])
    end

    it 'clears the current selection' do
      select('', from: 'Draft')
      click_button 'Save'
      @player.reload
      expect(@player.draft).to be nil
    end
  end

  describe 'on show' do
    before do
      @player = FactoryBot.create :player
      @draft  = FactoryBot.create :draft, player: @player
      visit show_path(model_name: 'player', id: @player.id)
    end

    it 'shows associated objects' do
      is_expected.to have_css("a[href='/admin/draft/#{@draft.id}']")
    end
  end

  context 'with custom primary_key option' do
    let(:user) { FactoryBot.create :managing_user }
    let!(:team) { FactoryBot.create(:managed_team) }
    before do
      RailsAdmin.config.included_models = [ManagingUser, ManagedTeam]
      RailsAdmin.config ManagingUser do
        field :team
      end
    end

    it 'allows update' do
      visit edit_path(model_name: 'managing_user', id: user.id)
      select(team.name, from: 'Team')
      click_button 'Save'
      is_expected.to have_content 'Managing user successfully updated'
      expect(ManagingUser.first.team).to eq team
    end

    context 'when fetching associated objects via xhr' do
      before do
        RailsAdmin.config ManagingUser do
          field(:team) { associated_collection_cache_all false }
        end
      end

      it 'allows update', js: true do
        visit edit_path(model_name: 'managing_user', id: user.id)
        find('input.ra-filtering-select-input').set('T')
        page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
        expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item a')
        page.execute_script %{[...document.querySelectorAll('ul.ui-autocomplete li.ui-menu-item')].find(e => e.innerText.includes("#{team.name}")).click()}
        click_button 'Save'
        is_expected.to have_content 'Managing user successfully updated'
        expect(ManagingUser.first.team).to eq team
      end
    end
  end

  context 'with composite foreign keys', composite_primary_keys: true do
    let(:fan) { FactoryBot.create(:fan) }
    let!(:fanship) { FactoryBot.create(:fanship, fan: fan) }

    describe 'via default field' do
      before do
        RailsAdmin.config Fan do
          field :name
          field :fanship
        end
      end

      it 'allows create' do
        visit new_path(model_name: 'fan')
        fill_in 'Name', with: 'someone'
        select("Fanship ##{fanship.id}", from: 'Fanship')
        click_button 'Save'
        is_expected.to have_content 'Fan successfully created'
        expect(Fan.where(name: 'someone').first.fanship.team_id).to eq fanship.team_id
      end

      it 'shows the current selection' do
        visit edit_path(model_name: 'fan', id: fanship.fan_id)
        is_expected.to have_select('Fanship', selected: "Fanship ##{fanship.id}")
      end
    end

    describe 'via remote-sourced field' do
      before do
        RailsAdmin.config Fan do
          field :name
          field :fanship do
            associated_collection_cache_all false
          end
        end
      end

      it 'allows create', js: true do
        visit new_path(model_name: 'fan')
        fill_in 'Name', with: 'someone'
        find('.fanship_field input.ra-filtering-select-input').set(fanship.fan_id)
        page.execute_script("document.querySelector('.fanship_field input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
        expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item a')
        page.execute_script %{[...document.querySelectorAll('ul.ui-autocomplete li.ui-menu-item')].find(e => e.innerText.includes("Fanship ##{fanship.id}")).click()}
        click_button 'Save'
        is_expected.to have_content 'Fan successfully created'
        expect(Fan.where(name: 'someone').first.fanship.team_id).to eq fanship.team_id
      end
    end

    describe 'via nested field' do
      let!(:team) { FactoryBot.create :team }
      before do
        RailsAdmin.config NestedFan do
          field :name
          field :fanship
        end
      end

      it 'allows update' do
        visit edit_path(model_name: 'nested_fan', id: fanship.fan_id)
        select(team.name, from: 'Team')
        fill_in 'Since', with: '2020-01-23'
        click_button 'Save'
        is_expected.to have_content 'Nested fan successfully updated'
        expect(fan.fanship.team).to eq team
        expect(fan.fanship.since).to eq Date.new(2020, 1, 23)
      end
    end
  end
end
