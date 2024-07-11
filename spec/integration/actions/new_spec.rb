

require 'spec_helper'

RSpec.describe 'New action', type: :request do
  subject { page }

  describe 'page' do
    before do
      visit new_path(model_name: 'player')
    end

    it 'shows "New Model"' do
      is_expected.to have_content('New Player')
    end

    it 'shows required fields as "Required"' do
      is_expected.to have_selector('div', text: /Name\s*Required/)
      is_expected.to have_selector('div', text: /Number\s*Required/)
    end

    it 'shows non-required fields as "Optional"' do
      is_expected.to have_selector('#player_position_field .form-text', text: 'Optional')
      is_expected.to have_selector('#player_born_on_field .form-text', text: 'Optional')
      is_expected.to have_selector('#player_notes_field .form-text', text: 'Optional')
    end

    # https://github.com/railsadminteam/rails_admin/issues/362
    # test that no link uses the "wildcard route" with the main
    # controller and new method
    it "does not use the 'wildcard route'" do
      is_expected.to have_no_selector("a[href^='/rails_admin/main/new']")
    end
  end

  context 'with missing label' do
    before do
      FactoryBot.create :team, name: ''
      visit new_path(model_name: 'player')
    end
  end

  context 'with parameters for pre-population' do
    it 'populates form field when corresponding parameters are passed in' do
      visit new_path(model_name: 'player', player: {name: 'Sam'})
      expect(page).to have_css('input[value=Sam]')
    end

    it 'prepropulates has_one relationships' do
      @draft = FactoryBot.create :draft
      @player = FactoryBot.create :player, name: 'has_one association prepopulated'
      visit new_path(model_name: 'player', player: {draft_id: @draft.id})
      expect(page).to have_css("select#player_draft_id option[selected='selected'][value='#{@draft.id}']")
    end

    it 'prepropulates has_many relationships' do
      @player = FactoryBot.create :player, name: 'has_many association prepopulated'
      visit new_path(model_name: 'team', team: {player_ids: [@player.id]})
      expect(page).to have_css("select#team_player_ids option[selected='selected'][value='#{@player.id}']")
    end
  end

  context 'with namespaced model' do
    it 'has correct input field names' do
      visit new_path(model_name: 'cms~basic_page')
      is_expected.to have_selector('label[for=cms_basic_page_title]')
      is_expected.to have_selector("input#cms_basic_page_title[name='cms_basic_page[title]']")
      is_expected.to have_selector('label[for=cms_basic_page_content]')
      is_expected.to have_selector("textarea#cms_basic_page_content[name='cms_basic_page[content]']")
    end

    context 'with parameters for pre-population' do
      it 'populates form field when corresponding parameters are passed in' do
        visit new_path(model_name: 'cms~basic_page', cms_basic_page: {title: 'Hello'})
        expect(page).to have_css('input[value=Hello]')
      end
    end

    it 'creates object with correct attributes' do
      visit new_path(model_name: 'cms~basic_page')

      fill_in 'cms_basic_page[title]', with: 'Hello'
      fill_in 'cms_basic_page[content]', with: 'World'
      expect do
        click_button 'Save' # first(:button, "Save").click
      end.to change(Cms::BasicPage, :count).by(1)
    end
  end

  context 'on create' do
    before do
      visit new_path(model_name: 'player')
      fill_in 'player[name]', with: 'Jackie Robinson'
      fill_in 'player[number]', with: '42'
      fill_in 'player[position]', with: 'Second baseman'
      click_button 'Save'
      @player = RailsAdmin::AbstractModel.new('Player').first
    end

    it 'creates an object with correct attributes' do
      expect(@player.name).to eq('Jackie Robinson')
      expect(@player.number).to eq(42)
      expect(@player.position).to eq('Second baseman')
    end
  end

  context 'on create and edit' do
    before do
      visit new_path(model_name: 'player')

      fill_in 'player[name]', with: 'Jackie Robinson'
      fill_in 'player[number]', with: '42'
      fill_in 'player[position]', with: 'Second baseman'
      click_button 'Save and edit'

      @player = RailsAdmin::AbstractModel.new('Player').first
    end

    it 'creates an object with correct attributes' do
      expect(@player.name).to eq('Jackie Robinson')
      expect(@player.number).to eq(42)
      expect(@player.position).to eq('Second baseman')
    end
  end

  context 'on create and add another', js: true do
    before do
      visit new_path(model_name: 'player')

      fill_in 'player[name]', with: 'Jackie Robinson'
      fill_in 'player[number]', with: '42'
      fill_in 'player[position]', with: 'Second baseman'
      find_button('Save and add another').trigger('click')
    end

    it 'creates an object with correct attributes' do
      is_expected.to have_text 'Player successfully created'
      expect(page.current_path).to eq('/admin/player/new')

      @player = RailsAdmin::AbstractModel.new('Player').first
      expect(@player.name).to eq('Jackie Robinson')
      expect(@player.number).to eq(42)
      expect(@player.position).to eq('Second baseman')
    end
  end

  context 'with uniqueness constraint violated', given: 'a player exists' do
    before do
      @team = FactoryBot.create :team
      @player = FactoryBot.create :player, team: @team

      post new_path(model_name: 'player', player: {name: @player.name, number: @player.number.to_s, position: @player.position, team_id: @team.id})
    end

    it 'shows an error message' do
      expect(response.body).to include('There is already a player with that number on this team')
    end
  end

  context 'with invalid object' do
    before do
      post new_path(model_name: 'player', player: {id: 1})
    end

    it 'shows an error message' do
      expect(response.body).to include('Player failed to be created')
    end
  end

  context 'with object with errors on base' do
    before do
      visit new_path(model_name: 'player')
      fill_in 'player[name]', with: 'Jackie Robinson on steroids'
      click_button 'Save and add another'
    end

    it 'shows error base error message in flash' do
      is_expected.to have_content('Player failed to be created')
      is_expected.to have_content('Player is cheating')
    end
  end

  context 'with a readonly object' do
    it 'shows non-editable form' do
      RailsAdmin.config do |config|
        config.model ReadOnlyComment do
          edit do
            field :content
          end
        end
      end
      visit new_path(model_name: 'read_only_comment')
      is_expected.not_to have_css('textarea[name="read_only_comment[content]"]')
      is_expected.to have_css('button[name="_save"]:disabled')
    end
  end

  context 'with composite_primary_keys', composite_primary_keys: true do
    let!(:fan) { FactoryBot.create(:fan) }
    let!(:team) { FactoryBot.create(:team) }

    it 'creates an object' do
      visit new_path(model_name: 'fanship')
      select(fan.name, from: 'Fan')
      select(team.name, from: 'Team')
      expect { click_button 'Save' }.to change { Fanship.count }.by(1)
      expect(Fanship.first.attributes.fetch_values('fan_id', 'team_id')).to eq [fan.id, team.id]
    end
  end
end
