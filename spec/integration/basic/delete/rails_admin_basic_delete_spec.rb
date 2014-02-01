require 'spec_helper'

describe 'RailsAdmin Basic Delete' do

  subject { page }

  describe 'delete' do
    it "shows \"Delete model\"" do
      @draft = FactoryGirl.create :draft
      @player = @draft.player
      @comment = @player.comments.create
      visit delete_path(model_name: 'player', id: @player.id)
      should have_content('delete this player')
      should have_link(@player.name, href: "/admin/player/#{@player.id}")
      should have_link("Draft ##{@draft.id}", href: "/admin/draft/#{@draft.id}")
      should have_link("Comment ##{@comment.id}", href: "/admin/comment/#{@comment.id}")
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
      should have_content('delete this player')
      should_not have_selector("a[href=\"/admin/player/#{@player.id}\"]")
      should_not have_selector("a[href=\"/admin/draft/#{@draft.id}\"]")
      should_not have_selector("a[href=\"/admin/comment/#{@comment.id}\"]")
    end
  end

  describe 'delete of an object which has an associated item without id' do
    before do
      @player = FactoryGirl.create :player
      allow_any_instance_of(Player).to receive(:draft).and_return(Draft.new)
      visit delete_path(model_name: 'player', id: @player.id)
    end

    it "shows \"Delete model\"" do
      should_not have_content('Routing Error')
      should have_content('delete this player')
      should have_link(@player.name, href: "/admin/player/#{@player.id}")
    end
  end
end
