

require 'spec_helper'

RSpec.describe 'Delete action', type: :request do
  subject { page }

  it 'shows "Delete model"' do
    @draft = FactoryBot.create :draft
    @player = @draft.player
    @comment = @player.comments.create
    visit delete_path(model_name: 'player', id: @player.id)
    is_expected.to have_content('delete this player')
    is_expected.to have_link(@player.name, href: "/admin/player/#{@player.id}")
    is_expected.to have_link("Draft ##{@draft.id}", href: "/admin/draft/#{@draft.id}")
    is_expected.to have_link("Comment ##{@comment.id}", href: "/admin/comment/#{@comment.id}")
  end

  context 'with missing object' do
    before do
      visit delete_path(model_name: 'player', id: 1)
    end

    it 'raises NotFound' do
      expect(page.driver.status_code).to eq(404)
    end
  end

  context 'with show action disabled' do
    before do
      RailsAdmin.config.actions do
        dashboard
        index
        delete
      end
      @draft = FactoryBot.create :draft
      @player = @draft.player
      @comment = @player.comments.create
      visit delete_path(model_name: 'player', id: @player.id)
    end

    it 'shows "Delete model"' do
      is_expected.to have_content('delete this player')
      is_expected.not_to have_selector("a[href=\"/admin/player/#{@player.id}\"]")
      is_expected.not_to have_selector("a[href=\"/admin/draft/#{@draft.id}\"]")
      is_expected.not_to have_selector("a[href=\"/admin/comment/#{@comment.id}\"]")
    end
  end

  context 'on deleting an object which has an associated item without id' do
    before do
      @player = FactoryBot.create :player
      allow_any_instance_of(Player).to receive(:draft).and_return(Draft.new)
      visit delete_path(model_name: 'player', id: @player.id)
    end

    it 'shows "Delete model"' do
      is_expected.not_to have_content('Routing Error')
      is_expected.to have_content('delete this player')
      is_expected.to have_link(@player.name, href: "/admin/player/#{@player.id}")
    end
  end

  context 'on deleting an object which has many associated item' do
    before do
      comments = FactoryBot.create_list :comment, 20
      @player = FactoryBot.create :player, comments: comments
      visit delete_path(model_name: 'player', id: @player.id)
    end

    it 'shows only ten first plus x mores', skip_mongoid: true do
      is_expected.to have_selector('.comment', count: 10)
      is_expected.to have_content('Plus 10 more Comments')
    end
  end

  context 'on destroy' do
    before do
      @player = FactoryBot.create :player
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

  context 'with destroy errors' do
    before do
      allow_any_instance_of(Player).to receive(:destroy_hook) { throw :abort }
      @player = FactoryBot.create :player
      visit delete_path(model_name: 'player', id: @player.id)
      click_button "Yes, I'm sure"
    end

    it 'does not destroy an object' do
      expect(@player.reload).to be
    end

    it 'shows error message' do
      is_expected.to have_content('Player failed to be deleted')
    end

    it 'returns status code 406' do
      expect(page.status_code).to eq(406)
    end
  end

  context 'on destroy error by dependent: :restrict_with_error' do
    let!(:player) { FactoryBot.create :player, team: FactoryBot.create(:restricted_team) }
    before do
      visit delete_path(model_name: 'restricted_team', id: player.team.id)
      click_button "Yes, I'm sure"
      is_expected.to have_content('Restricted team failed to be deleted')
    end

    it 'shows error message', active_record: true do
      is_expected.to have_content('Cannot delete record because dependent players exist')
    end

    it 'shows error message', mongoid: true do
      is_expected.to have_content('Players is not empty and prevents the document from being destroyed')
    end
  end

  context 'on cancel' do
    before do
      @player = FactoryBot.create :player
      visit delete_path(model_name: 'player', id: @player.id)
    end

    it 'does not destroy an object', js: true do
      find_button('Cancel').trigger('click')
      is_expected.to have_text 'No actions were taken'
      expect(RailsAdmin::AbstractModel.new('Player').first).to be
    end
  end

  context 'with missing object' do
    before do
      delete delete_path(model_name: 'player', id: 1)
    end

    it 'raises NotFound' do
      expect(response.code).to eq('404')
    end
  end

  context 'when navigated to delete from show page' do
    it 'redirects to the index instead of trying to show the deleted object' do
      @player = FactoryBot.create :player
      visit show_path(model_name: 'player', id: @player.id)
      click_link 'Delete'
      click_button "Yes, I'm sure"

      expect(URI.parse(page.current_url).path).to eq(index_path(model_name: 'player'))
    end

    it 'stays on the delete page' do
      allow_any_instance_of(Player).to receive(:destroy_hook) { throw :abort }
      @player = FactoryBot.create :player
      visit show_path(model_name: 'player', id: @player.id)
      click_link 'Delete'
      click_button "Yes, I'm sure"

      expect(URI.parse(page.current_url).path).to eq(delete_path(model_name: 'player', id: @player.id))
    end
  end

  context 'with composite_primary_keys', composite_primary_keys: true do
    let(:fanship) { FactoryBot.create(:fanship) }

    it 'deletes the object' do
      visit delete_path(model_name: 'fanship', id: fanship.id)
      click_button "Yes, I'm sure"
      is_expected.to have_content('Fanship successfully deleted')
      expect(Fanship.all).to be_empty
    end
  end
end
