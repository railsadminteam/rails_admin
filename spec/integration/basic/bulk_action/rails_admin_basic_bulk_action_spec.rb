require 'spec_helper'

describe 'RailsAdmin Basic Bulk Action', type: :request do
  subject { page }

  before do
    @players = FactoryGirl.create_list(:player, 2)
  end

  describe 'bulk_delete' do
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

  describe 'bulk_export' do
    it 'shows form for export' do
      visit index_path(model_name: 'player')
      click_link 'Export found Players'
      @players.each { |_player| is_expected.to have_content('Select fields to export') }
    end
  end
end
