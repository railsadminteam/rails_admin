

require 'spec_helper'

RSpec.describe 'Filtering select widget', type: :request, js: true do
  subject { page }

  let!(:teams) { ['Los Angeles Dodgers', 'Texas Rangers'].map { |name| FactoryBot.create :team, name: name } }
  let(:player) { FactoryBot.create :player, team: teams[0] }
  before do
    RailsAdmin.config Player do
      field :team
      field :number
    end
  end

  context 'on create' do
    before { visit new_path(model_name: 'player') }

    it 'is initially unset' do
      expect(find('input.ra-filtering-select-input').value).to be_empty
      expect(find('#player_team_id', visible: false).value).to be_empty
    end

    it 'supports filtering' do
      find('input.ra-filtering-select-input').set('ge')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      expect(all(:css, 'ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to match_array ['Los Angeles Dodgers', 'Texas Rangers']
      find('input.ra-filtering-select-input').set('Los')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      expect(all(:css, 'ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to eq ['Los Angeles Dodgers']
      find('input.ra-filtering-select-input').set('Mets')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      expect(all(:css, 'ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to match_array ['No objects found']
    end

    it 'sets id of the selected item' do
      find('input.ra-filtering-select-input').set('Tex')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      page.execute_script %{[...document.querySelectorAll('ul.ui-autocomplete li.ui-menu-item')].find(e => e.innerText.includes("Texas Rangers")).click()}
      expect(find('#player_team_id', visible: false).value).to eq teams[1].id.to_s
    end
  end

  context 'on update' do
    it 'changes the selected value' do
      visit edit_path(model_name: 'player', id: player.id)
      expect(find('#player_team_id', visible: false).value).to eq teams[0].id.to_s
      find('input.ra-filtering-select-input').set('Tex')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      page.execute_script %{[...document.querySelectorAll('ul.ui-autocomplete li.ui-menu-item')].find(e => e.innerText.includes("Texas Rangers")).click()}
      expect(find('#player_team_id', visible: false).value).to eq teams[1].id.to_s
    end

    it 'clears the current selection with making the search box empty' do
      visit edit_path(model_name: 'player', id: player.id)
      find('input.ra-filtering-select-input').set('')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keyup'))")
      expect(find('#player_team_id', visible: false).value).to be_empty
    end

    it 'clears the current selection with selecting the clear option' do
      visit edit_path(model_name: 'player', id: player.id)
      within('.filtering-select') { find('.dropdown-toggle').click }
      find('a.ui-menu-item-wrapper', text: /Clear/).click
      expect(find('#player_team_id', visible: false).value).to be_empty
    end

    context 'when the field is required' do
      before do
        RailsAdmin.config Player do
          field(:team) { required true }
        end
        visit edit_path(model_name: 'player', id: player.id)
      end

      it 'does not show the clear option' do
        within('.filtering-select') { find('.dropdown-toggle').click }
        is_expected.not_to have_css('a.ui-menu-item-wrapper', text: /Clear/)
      end
    end
  end

  it 'prevents duplication when using browser back and forward' do
    player
    visit index_path(model_name: 'player')
    find(%([href$="/admin/player/#{player.id}/edit"])).click
    is_expected.to have_content 'Edit Player'
    page.go_back
    is_expected.to have_content 'List of Players'
    page.go_forward
    is_expected.to have_content 'Edit Player'
    expect(all(:css, 'input.ra-filtering-select-input').count).to eq 1
  end

  it 'does not lose options on browser back' do
    visit edit_path(model_name: 'player', id: player.id)
    find('.team_field .dropdown-toggle').click
    find('li.ui-menu-item a', text: /Clear/).click
    click_link 'Show'
    is_expected.to have_content 'Details for Player'
    page.go_back
    find('.team_field input.ra-filtering-select-input').set('Los')
    page.execute_script("document.querySelector('.team_field input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
    is_expected.to have_selector('ul.ui-autocomplete li.ui-menu-item a', text: 'Los Angeles Dodgers')
  end

  context 'when using remote requests' do
    before do
      RailsAdmin.config Player do
        field :team do
          associated_collection_cache_all false
        end
      end
      visit new_path(model_name: 'player')
    end

    it 'supports filtering' do
      find('input.ra-filtering-select-input').set('ge')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      expect(all(:css, 'ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to match_array ['Los Angeles Dodgers', 'Texas Rangers']
      teams[0].update name: 'Cincinnati Reds'
      find('input.ra-filtering-select-input').set('Red')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      is_expected.to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      expect(all(:css, 'ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to eq ['Cincinnati Reds']
    end
  end

  describe 'dynamic scoping' do
    let!(:players) { FactoryBot.create_list :player, 2, team: teams[1] }
    let!(:freelancer) { FactoryBot.create :player, team: nil }

    context 'with single field' do
      before do
        player
        RailsAdmin.config Draft do
          field :team
          field :player do
            dynamically_scope_by :team
          end
        end
        visit new_path(model_name: 'draft')
      end

      it 'changes selection candidates based on value of the specified field' do
        expect(all('#draft_player_id option', visible: false).map(&:value).filter(&:present?)).to be_empty
        find('[data-input-for="draft_team_id"] input.ra-filtering-select-input').set('Tex')
        page.execute_script(%{document.querySelector('[data-input-for="draft_team_id"] input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))})
        is_expected.to have_selector('ul.ui-autocomplete li.ui-menu-item a')
        page.execute_script %{[...document.querySelectorAll('ul.ui-autocomplete li.ui-menu-item')].find(e => e.innerText.includes("Texas Rangers")).click()}
        within('[data-input-for="draft_player_id"].filtering-select') { find('.dropdown-toggle').click }
        expect(all(:css, 'ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to match_array players.map(&:name)
      end

      it 'allows filtering by blank value' do
        within('[data-input-for="draft_player_id"].filtering-select') { find('.dropdown-toggle').click }
        expect(all(:css, 'ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to match_array [freelancer.name]
      end
    end

    context 'with multiple fields' do
      before do
        player
        RailsAdmin.config Draft do
          field :team
          field :player do
            dynamically_scope_by [:team, {round: :number}]
          end
          field :round
        end
        visit new_path(model_name: 'draft', draft: {team_id: teams[1].id})
      end

      it 'changes selection candidates based on value of the specified fields' do
        fill_in 'draft[round]', with: players[1].number
        within('[data-input-for="draft_player_id"].filtering-select') { find('.dropdown-toggle').click }
        expect(all(:css, 'ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to match_array [players[1].name]
      end
    end
  end
end
