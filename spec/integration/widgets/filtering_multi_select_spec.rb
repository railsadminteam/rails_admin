

require 'spec_helper'

RSpec.describe 'Filtering multi-select widget', type: :request, js: true do
  subject { page }

  let(:team) { FactoryBot.create :team }
  let!(:players) { ['Cory Burns', 'Leonys Martin', 'Matt Garza'].map { |name| FactoryBot.create :player, name: name } }
  before do
    RailsAdmin.config Team do
      field :players
    end
  end

  context 'on create' do
    before { visit new_path(model_name: 'team') }

    it 'is initially unset' do
      expect(all('.ra-multiselect-collection option').map(&:text)).to match_array ['Leonys Martin', 'Cory Burns', 'Matt Garza']
      expect(find('.ra-multiselect-selection').text).to be_empty
    end

    it 'supports filtering' do
      find('input.ra-multiselect-search').set('Alex')
      page.execute_script("document.querySelector('input.ra-multiselect-search').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_content 'No objects found'
      find('input.ra-multiselect-search').set('Ma')
      page.execute_script("document.querySelector('input.ra-multiselect-search').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_content 'Leonys'
      expect(all('.ra-multiselect-collection option').map(&:text)).to match_array ['Leonys Martin', 'Matt Garza']
    end

    it 'sets ids of the selected items' do
      find('.ra-multiselect-collection option', text: /Cory/).select_option
      within('.ra-multiselect-center') { click_link 'Add new' }
      expect(all('.ra-multiselect-selection option').map(&:text)).to match_array ['Cory Burns']
      expect(all('.ra-multiselect-collection option').map(&:text)).to match_array ['Leonys Martin', 'Matt Garza']
      expect(all('#team_player_ids option', visible: false).select(&:selected?).map(&:value)).to match_array [players[0].id.to_s]
    end
  end

  context 'on update' do
    let!(:player) { FactoryBot.create :player, team: team, name: 'Elvis Andrus' }
    before { visit edit_path(model_name: 'team', id: team.id) }

    it 'additionally selects items' do
      expect(all('#team_player_ids option', visible: false).select(&:selected?).map(&:value)).to match_array [player.id.to_s]
      find('.ra-multiselect-collection option', text: /Cory/).select_option
      within('.ra-multiselect-center') { click_link 'Add new' }
      expect(all('#team_player_ids option', visible: false).select(&:selected?).map(&:value)).to match_array [players[0].id.to_s, player.id.to_s]
    end

    it 'deselects the current selection' do
      find('.ra-multiselect-selection option', text: /Elvis/).select_option
      within('.ra-multiselect-center') { click_link 'Remove' }
      expect(all('.ra-multiselect-selection option').map(&:text)).to be_empty
      expect(all('.ra-multiselect-collection option').map(&:text)).to match_array ['Cory Burns', 'Leonys Martin', 'Matt Garza', 'Elvis Andrus']
      expect(all('#team_player_ids option', visible: false).select(&:selected?).map(&:value)).to be_empty
    end
  end

  describe 'Choose all button' do
    it 'picks all available items' do
      visit edit_path(model_name: 'team', id: team.id)
      click_link 'Choose all'
      expect(all(:css, '#team_player_ids option', visible: false).map(&:value)).to match_array players.map(&:id).map(&:to_s)
    end
  end

  describe 'Clear all button' do
    let!(:player) { FactoryBot.create :player, team: team, name: 'Elvis Andrus' }

    it 'removes all selected items' do
      visit edit_path(model_name: 'team', id: team.id)
      find('.ra-multiselect-collection option', text: /Cory/).select_option
      within('.ra-multiselect-center') { click_link 'Add new' }
      expect(all('.ra-multiselect-selection option').map(&:text)).to match_array ['Cory Burns', 'Elvis Andrus']
      click_link 'Clear all'
      expect(all(:css, '#team_player_ids option', visible: false).select(&:selected?).map(&:value)).to be_empty
    end
  end

  context 'when using remote requests' do
    before do
      RailsAdmin.config Team do
        field(:players) { associated_collection_cache_all false }
      end
      visit edit_path(model_name: 'team', id: team.id)
    end

    it 'supports filtering' do
      find('input.ra-multiselect-search').set('Alex')
      page.execute_script("document.querySelector('input.ra-multiselect-search').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_content 'No objects found'
      players[2].update name: 'Adam Rosales'
      find('input.ra-multiselect-search').set('Ma')
      page.execute_script("document.querySelector('input.ra-multiselect-search').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_content 'Leonys'
      expect(all('.ra-multiselect-collection option').map(&:text)).to match_array ['Leonys Martin']
    end

    describe 'Choose all button' do
      it 'does not pick the placeholder for selection' do
        click_link 'Choose all'
        expect(page).not_to have_css('#team_player_ids option', visible: false)
        expect(page).not_to have_css('.ra-multiselect-selection option')
      end

      it 'picks all available items' do
        find('input.ra-multiselect-search').set('Ma')
        page.execute_script("document.querySelector('input.ra-multiselect-search').dispatchEvent(new KeyboardEvent('keydown'))")
        expect(page).to have_css('.ra-multiselect-collection option', text: /Matt/)
        click_link 'Choose all'
        expect(all(:css, '#team_player_ids option', visible: false).map(&:value)).to match_array players[1..2].map(&:id).map(&:to_s)
      end
    end
  end

  it 'does not cause duplication when using browser back' do
    visit new_path(model_name: 'team')
    find(%([href$="/admin/team/export"])).click
    is_expected.to have_content 'Export Teams'
    page.go_back
    is_expected.to have_content 'New Team'
    expect(all(:css, 'input.ra-multiselect-search').count).to eq 1
  end

  describe 'dynamic scoping' do
    let!(:team) { FactoryBot.create :team, division: FactoryBot.create(:division) }
    let(:division) { FactoryBot.create(:division) }
    let!(:teams) { ['Los Angeles Dodgers', 'Texas Rangers'].map { |name| FactoryBot.create :team, name: name, division: division } }
    before do
      RailsAdmin.config Team do
        field :name
        field :division
      end
      RailsAdmin.config Fan do
        field :division, :enum do
          enum { Division.pluck(:name, CI_ORM == :active_record ? :custom_id : :id).to_h }
          def value
            nil
          end

          def parse_input(params)
            params.delete :division
          end
        end
        field :teams do
          dynamically_scope_by :division
        end
      end
      visit new_path(model_name: 'fan')
    end

    it 'changes selection candidates based on value of the specified field' do
      expect(all('#fan_team_ids option', visible: false).map(&:value).filter(&:present?)).to be_empty
      select division.name, from: 'Division', visible: false
      find('input.ra-multiselect-search').set('e')
      page.execute_script("document.querySelector('input.ra-multiselect-search').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_content 'Dodgers'
      expect(all('.ra-multiselect-collection option').map(&:text)).to match_array ['Los Angeles Dodgers', 'Texas Rangers']
    end
  end
end
