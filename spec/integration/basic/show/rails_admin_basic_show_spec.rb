require 'spec_helper'

describe 'RailsAdmin Basic Show', type: :request do
  subject { page }

  describe 'show' do
    it 'has History, Edit, Delete, Details and attributes' do
      @player = FactoryGirl.create :player
      visit show_path(model_name: 'player', id: @player.id)

      is_expected.to have_selector('a', text: 'History')
      is_expected.to have_selector('a', text: 'Edit')
      is_expected.to have_selector('a', text: 'Delete')
      is_expected.to have_content('Details')
      is_expected.to have_content('Name')
      is_expected.to have_content(@player.name)
      is_expected.to have_content('Number')
      is_expected.to have_content(@player.number)
    end
  end

  describe 'GET /admin/players/123this-id-doesnt-exist' do
    it 'raises NotFound' do
      visit '/admin/players/123this-id-doesnt-exist'
      expect(page.driver.status_code).to eq(404)
    end
  end

  describe 'show with belongs_to association' do
    before do
      @player = FactoryGirl.create :player
      @team   = FactoryGirl.create :team
      @player.update_attributes(team_id: @team.id)
      visit show_path(model_name: 'player', id: @player.id)
    end

    it 'shows associated objects' do
      is_expected.to have_css("a[href='/admin/team/#{@team.id}']")
    end
  end

  describe 'show with has-one association' do
    before do
      @player = FactoryGirl.create :player
      @draft  = FactoryGirl.create :draft, player: @player
      visit show_path(model_name: 'player', id: @player.id)
    end

    it 'shows associated objects' do
      is_expected.to have_css("a[href='/admin/draft/#{@draft.id}']")
    end
  end

  describe 'show with has-and-belongs-to-many association' do
    before do
      @player = FactoryGirl.create :player
      @comment1 = FactoryGirl.create :comment, commentable: @player
      @comment2 = FactoryGirl.create :comment, commentable: @player
      @comment3 = FactoryGirl.create :comment, commentable: FactoryGirl.create(:player)

      visit show_path(model_name: 'player', id: @player.id)
    end

    it 'shows associated objects' do
      is_expected.to have_css("a[href='/admin/comment/#{@comment1.id}']")
      is_expected.to have_css("a[href='/admin/comment/#{@comment2.id}']")
      is_expected.not_to have_css("a[href='/admin/comment/#{@comment3.id}']")
    end
  end

  describe 'show for polymorphic objects' do
    before do
      @player = FactoryGirl.create :player
      @comment = FactoryGirl.create :comment, commentable: @player
      visit show_path(model_name: 'comment', id: @comment.id)
    end

    it 'shows associated object' do
      is_expected.to have_css("a[href='/admin/player/#{@player.id}']")
    end
  end
end
