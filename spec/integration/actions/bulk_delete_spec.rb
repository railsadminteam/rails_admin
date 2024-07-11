

require 'spec_helper'

RSpec.describe 'BulkDelete action', type: :request do
  subject { page }

  describe 'confirmation page' do
    before do
      @players = FactoryBot.create_list(:player, 2)
    end

    it 'shows names of to-be-deleted players' do
      post(bulk_action_path(bulk_action: 'bulk_delete', model_name: 'player', bulk_ids: @players.collect(&:id)))
      @players.each { |player| expect(response.body).to include(player.name) }
    end

    it 'redirects to list when all of the records is already deleted' do
      expect(Player.count).to eq @players.length
      player_ids = [@players.first.id]
      @players.first.destroy # delete selected object before send request to show bulk_delete confirmation.

      post(bulk_action_path(bulk_action: 'bulk_delete', model_name: 'player', bulk_ids: player_ids))
      expect(response.response_code).to eq 302

      index_url = response.headers['Location']
      expect(URI.parse(index_url).path).to eq(index_path(model_name: 'player'))
      visit index_url

      is_expected.to have_no_content(@players.first.name)
      is_expected.to have_content(@players.last.name)
    end

    it 'returns error message for DELETE request if the records are already deleted' do
      expect(Player.count).to eq @players.length
      player_ids = [@players.first.id]
      @players.first.destroy # delete selected object before send request to delete it.

      delete(bulk_delete_path(bulk_action: 'bulk_delete', model_name: 'player', bulk_ids: player_ids))
      expect(response.response_code).to eq 302
      expect(flash[:error]).to match(/0 players failed to be deleted/i)
    end

    it 'returns error message for DELETE request without bulk_ids' do
      expect(Player.count).to eq @players.length
      delete(bulk_delete_path(bulk_action: 'bulk_delete', model_name: 'player', bulk_ids: ''))
      expect(response.response_code).to eq 302
      expect(flash[:error]).to match(/0 players failed to be deleted/i)
    end
  end

  context 'on destroy' do
    before do
      @players = Array.new(3) { FactoryBot.create(:player) }
      @delete_ids = @players[0..1].collect(&:id)

      # NOTE: This uses an internal, unsupported capybara API which could break at any moment. We
      # should refactor this test so that it either A) uses capybara's supported API (only GET
      # requests via visit) or B) just uses Rack::Test (and doesn't use capybara for browser
      # interaction like click_button).
      page.driver.browser.reset_host!
      page.driver.browser.process :post, bulk_action_path(bulk_action: 'bulk_delete', model_name: 'player', bulk_ids: @delete_ids, '_method' => 'post')
      click_button "Yes, I'm sure"
    end

    it 'does not contain deleted records' do
      expect(RailsAdmin::AbstractModel.new('Player').all.pluck(:id)).to eq([@players[2].id])
      expect(page).to have_selector('.alert-success', text: '2 Players successfully deleted')
    end
  end

  context 'on cancel' do
    before do
      @players = Array.new(3) { FactoryBot.create(:player) }
      @delete_ids = @players[0..1].collect(&:id)

      visit index_path(model_name: 'player')
      @delete_ids.each { |id| find(%(input[name="bulk_ids[]"][value="#{id}"])).click }
      click_link 'Selected items'
      click_link 'Delete selected Players'
    end

    it 'does not delete records', js: true do
      find_button('Cancel').trigger('click')
      is_expected.to have_text 'No actions were taken'
      expect(RailsAdmin::AbstractModel.new('Player').count).to eq(3)
    end
  end

  context 'with composite_primary_keys', composite_primary_keys: true do
    let!(:fanships) { FactoryBot.create_list(:fanship, 3) }

    it 'provides check boxes for bulk operation' do
      visit index_path(model_name: 'fanship')
      fanships.each { |fanship| is_expected.to have_css(%(input[name="bulk_ids[]"][value="#{fanship.id}"])) }
    end

    it 'deletes selected records' do
      delete(bulk_delete_path(bulk_action: 'bulk_delete', model_name: 'fanship', bulk_ids: fanships[0..1].map { |fanship| fanship.id.to_s }))
      expect(flash[:success]).to match(/2 Fanships successfully deleted/)
      expect(Fanship.all).to eq fanships[2..2]
    end
  end
end
