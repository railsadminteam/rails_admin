

require 'spec_helper'

RSpec.describe 'PolymorphicAssociation field', type: :request do
  subject { page }

  context 'on create' do
    it 'is editable', js: true do
      @players = ['Jackie Robinson', 'Rob Wooten'].map { |name| FactoryBot.create :player, name: name }
      visit new_path(model_name: 'comment')
      select 'Player', from: 'comment[commentable_type]'
      find('input.ra-filtering-select-input').set('Rob')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      page.execute_script %{[...document.querySelectorAll('ul.ui-autocomplete li.ui-menu-item')].find(e => e.innerText.includes("Jackie Robinson")).click()}
      click_button 'Save'
      is_expected.to have_content 'Comment successfully created'
      expect(Comment.first.commentable).to eq @players[0]
    end

    it 'uses base class for models with inheritance' do
      @hardball = FactoryBot.create :hardball
      post new_path(model_name: 'comment', comment: {commentable_type: 'Hardball', commentable_id: @hardball.id})
      @comment = Comment.first
      expect(@comment.commentable_type).to eq 'Ball'
      expect(@comment.commentable).to eq @hardball
    end

    context 'when the associated model is declared in a two-level namespace' do
      it 'successfully saves the record', js: true do
        polymorphic_association_tests = ['Jackie Robinson', 'Rob Wooten'].map do |name|
          FactoryBot.create(:two_level_namespaced_polymorphic_association_test, name: name)
        end

        visit new_path(model_name: 'comment')

        select 'Polymorphic association test', from: 'comment[commentable_type]'
        find('input.ra-filtering-select-input').set('Rob')

        page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
        expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item a')

        page.execute_script %{[...document.querySelectorAll('ul.ui-autocomplete li.ui-menu-item')].find(e => e.innerText.includes("Jackie Robinson")).click()}
        click_button 'Save'
        is_expected.to have_content 'Comment successfully created'
        expect(Comment.first.commentable).to eq polymorphic_association_tests.first
      end
    end
  end

  context 'on update' do
    let(:team) { FactoryBot.create :team, name: 'Los Angeles Dodgers' }
    let(:comment) { FactoryBot.create :comment, commentable: team }
    let!(:players) { ['Jackie Robinson', 'Rob Wooten', 'Scott Hairston'].map { |name| FactoryBot.create :player, name: name } }

    it 'is editable', js: true do
      visit edit_path(model_name: 'comment', id: comment.id)
      expect(find('select#comment_commentable_type').value).to eq 'Team'
      expect(find('select#comment_commentable_id', visible: false).value).to eq team.id.to_s
      find('input.ra-filtering-select-input').set('Los')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      expect(all('ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to eq ['Los Angeles Dodgers']
      select 'Player', from: 'comment[commentable_type]'
      find('input.ra-filtering-select-input').set('Rob')
      page.execute_script("document.querySelector('input.ra-filtering-select-input').dispatchEvent(new KeyboardEvent('keydown'))")
      expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item a')
      expect(all('ul.ui-autocomplete li.ui-menu-item a').map(&:text)).to eq ['Rob Wooten', 'Jackie Robinson']
      page.execute_script %{[...document.querySelectorAll('ul.ui-autocomplete li.ui-menu-item')].find(e => e.innerText.includes("Jackie Robinson")).click()}
      click_button 'Save'
      is_expected.to have_content 'Comment successfully updated'
      expect(comment.reload.commentable).to eq players[0]
    end

    it 'is visible in the owning end' do
      visit edit_path(model_name: 'team', id: team.id)

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
