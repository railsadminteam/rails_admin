require 'spec_helper'

describe 'RailsAdmin Basic Delete', type: :request do
  subject { page }

  describe 'delete' do
    it "shows \"Delete model\"" do
      @draft = FactoryGirl.create :draft
      @player = @draft.player
      @comment = @player.comments.create
      visit delete_path(model_name: 'player', id: @player.id)
      is_expected.to have_content('delete this player')
      is_expected.to have_link(@player.name, href: "/admin/player/#{@player.id}")
      is_expected.to have_link("Draft ##{@draft.id}", href: "/admin/draft/#{@draft.id}")
      is_expected.to have_link("Comment ##{@comment.id}", href: "/admin/comment/#{@comment.id}")
    end
  end

  describe 'delete with missing object' do
    before do
      visit delete_path(model_name: 'player', id: 1)
    end

    it 'raises NotFound' do
      expect(page.driver.status_code).to eq(404)
    end
  end

  describe 'with show action disabled' do
    before do
      RailsAdmin.config.actions do
        dashboard
        index
        delete
      end
      @draft = FactoryGirl.create :draft
      @player = @draft.player
      @comment = @player.comments.create
      visit delete_path(model_name: 'player', id: @player.id)
    end

    it "shows \"Delete model\"" do
      is_expected.to have_content('delete this player')
      is_expected.not_to have_selector("a[href=\"/admin/player/#{@player.id}\"]")
      is_expected.not_to have_selector("a[href=\"/admin/draft/#{@draft.id}\"]")
      is_expected.not_to have_selector("a[href=\"/admin/comment/#{@comment.id}\"]")
    end
  end

  describe 'delete of an object which has an associated item without id' do
    before do
      @player = FactoryGirl.create :player
      allow_any_instance_of(Player).to receive(:draft).and_return(Draft.new)
      visit delete_path(model_name: 'player', id: @player.id)
    end

    it "shows \"Delete model\"" do
      is_expected.not_to have_content('Routing Error')
      is_expected.to have_content('delete this player')
      is_expected.to have_link(@player.name, href: "/admin/player/#{@player.id}")
    end
  end

  describe 'delete an object which has many associated item' do
    before do
      comments = FactoryGirl.create_list :comment, 20
      @player = FactoryGirl.create :player, comments: comments
      visit delete_path(model_name: 'player', id: @player.id)
    end

    it 'shows only ten first plus x mores', skip_mongoid: true do
      is_expected.to have_selector('.comment', count: 10)
      is_expected.to have_content('Plus 10 more Comments')
    end
  end
end
