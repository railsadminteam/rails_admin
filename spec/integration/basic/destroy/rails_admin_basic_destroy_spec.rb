require 'spec_helper'

describe 'RailsAdmin Basic Destroy', type: :request do
  subject { page }

  describe 'destroy' do
    before do
      @player = FactoryGirl.create :player
      visit delete_path(model_name: 'player', id: @player.id)
      click_button "Yes, I'm sure"
      @player = RailsAdmin::AbstractModel.new('Player').first
    end

    it 'destroys an object' do
      expect(@player).to be_nil
    end

    it 'shows success message' do
      is_expected.to have_content('Player successfully deleted')
    end
  end

  describe 'handle destroy errors' do
    before do
      allow_any_instance_of(Player).to receive(:destroy_hook).and_return false
      @player = FactoryGirl.create :player
      visit delete_path(model_name: 'player', id: @player.id)
      click_button "Yes, I'm sure"
    end

    it 'does not destroy an object' do
      expect(@player.reload).to be
    end

    it 'shows error message' do
      is_expected.to have_content('Player failed to be deleted')
    end
  end

  describe 'destroy' do
    before do
      @player = FactoryGirl.create :player
      visit delete_path(model_name: 'player', id: @player.id)
      click_button 'Cancel'
      @player = RailsAdmin::AbstractModel.new('Player').first
    end

    it 'does not destroy an object' do
      expect(@player).to be
    end
  end

  describe 'destroy with missing object' do
    before do
      delete delete_path(model_name: 'player', id: 1)
    end

    it 'raises NotFound' do
      expect(response.code).to eq('404')
    end
  end

  describe 'destroy from show page' do
    it 'redirects to the index instead of trying to show the deleted object' do
      @player = FactoryGirl.create :player
      visit show_path(model_name: 'player', id: @player.id)
      click_link 'Delete'
      click_button "Yes, I'm sure"

      expect(URI.parse(page.current_url).path).to eq(index_path(model_name: 'player'))
    end

    it 'redirects back to the object on error' do
      allow_any_instance_of(Player).to receive(:destroy_hook).and_return false
      @player = FactoryGirl.create :player
      visit show_path(model_name: 'player', id: @player.id)
      click_link 'Delete'
      click_button "Yes, I'm sure"

      expect(URI.parse(page.current_url).path).to eq(show_path(model_name: 'player', id: @player.id))
    end
  end
end
