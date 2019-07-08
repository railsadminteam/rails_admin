require 'spec_helper'

RSpec.describe 'PolymorphicAssociation field', type: :request do
  subject { page }

  context 'on create' do
    it 'is editable', js: true do
      @players = ['Jackie Robinson', 'Rob Wooten'].map { |name| FactoryBot.create :player, name: name }
      visit new_path(model_name: 'comment')
      select 'Player', from: 'comment[commentable_type]'
      find('input.ra-filtering-select-input').set('Rob')
      page.execute_script("$('input.ra-filtering-select-input').trigger('focus')")
      page.execute_script("$('input.ra-filtering-select-input').trigger('keydown')")
      expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      page.execute_script %{$('ul.ui-autocomplete li.ui-menu-item a:contains("Jackie Robinson")').trigger('mouseenter').click()}
      click_button 'Save'
      expect(Comment.first.commentable).to eq @players[0]
    end

    it 'uses base class for models with inheritance' do
      @hardball = FactoryBot.create :hardball
      post new_path(model_name: 'comment', comment: {commentable_type: 'Hardball', commentable_id: @hardball.id})
      @comment = Comment.first
      expect(@comment.commentable_type).to eq 'Ball'
      expect(@comment.commentable).to eq @hardball
    end
  end

  context 'on update' do
    before :each do
      @team = FactoryBot.create :team
      @comment = FactoryBot.create :comment, commentable: @team
    end

    it 'is editable' do
      visit edit_path(model_name: 'comment', id: @comment.id)

      is_expected.to have_selector('select#comment_commentable_type')
      is_expected.to have_selector('select#comment_commentable_id')
    end

    it 'is visible in the owning end' do
      visit edit_path(model_name: 'team', id: @team.id)

      is_expected.to have_selector('select#team_comment_ids')
    end
  end

  context 'on show' do
    before do
      @player = FactoryBot.create :player
      @comment = FactoryBot.create :comment, commentable: @player
      visit show_path(model_name: 'comment', id: @comment.id)
    end

    it 'shows associated object' do
      is_expected.to have_css("a[href='/admin/player/#{@player.id}']")
    end
  end

  context 'on list' do
    before :each do
      @team = FactoryBot.create :team
      @comment = FactoryBot.create :comment, commentable: @team
    end

    it 'works like belongs to associations in the list view' do
      visit index_path(model_name: 'comment')

      is_expected.to have_content(@team.name)
    end
  end
end
