require 'spec_helper'

describe 'RailsAdmin Basic Bulk Action' do

  subject { page }

  before do
    @players = 2.times.collect { FactoryGirl.create :player }
  end

  describe 'bulk_delete' do
    it 'shows names of to-be-deleted players' do
      post(bulk_action_path(bulk_action: 'bulk_delete', model_name: 'player', bulk_ids: @players.collect(&:id)))
      @players.each { |player| expect(response.body).to include(player.name) }
    end
  end

  describe 'bulk_export' do
    it 'shows form for export' do
      visit index_path(model_name: 'player')
      click_link 'Export found Players'
      @players.each { |player| should have_content('Select fields to export') }
    end
  end
end
