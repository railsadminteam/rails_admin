

require 'spec_helper'

RSpec.describe 'HasAndBelongsToManyAssociation field', type: :request do
  subject { page }

  context 'on create' do
    before do
      @teams = FactoryBot.create_list(:team, 3)
      post new_path(model_name: 'fan', fan: {name: 'John Doe', team_ids: [@teams[0].id]})
      @fan = RailsAdmin::AbstractModel.new('Fan').first
    end

    it 'creates an object with correct associations' do
      @teams[0].reload
      expect(@fan.teams).to include(@teams[0])
      expect(@fan.teams).not_to include(@teams[1])
      expect(@fan.teams).not_to include(@teams[2])
    end
  end

  describe 'on update' do
    before do
      @teams = FactoryBot.create_list(:team, 3)
      @fan = FactoryBot.create :fan, teams: [@teams[0]]
      visit edit_path(model_name: 'fan', id: @fan.id)
    end

    it 'shows associated objects' do
      is_expected.to have_selector '#fan_team_ids' do |select|
        options = select.all 'option'

        expect(options[0]['selected']).to eq 'selected'
        expect(options[1]['selected']).to eq nil
        expect(options[2]['selected']).to eq nil
      end
    end
  end

  describe 'on show' do
    before do
      @player = FactoryBot.create :player
      @comment1 = FactoryBot.create :comment, commentable: @player
      @comment2 = FactoryBot.create :comment, commentable: @player
      @comment3 = FactoryBot.create :comment, commentable: FactoryBot.create(:player)

      visit show_path(model_name: 'player', id: @player.id)
    end

    it 'shows associated objects' do
      is_expected.to have_css("a[href='/admin/comment/#{@comment1.id}']")
      is_expected.to have_css("a[href='/admin/comment/#{@comment2.id}']")
      is_expected.not_to have_css("a[href='/admin/comment/#{@comment3.id}']")
    end
  end

  context "with Mongoid's custom primary_key option", mongoid: true do
    let(:user) { FactoryBot.create :managing_user, players: [players[0]], balls: [balls[0]] }
    let!(:players) { FactoryBot.create_list(:player, 2) }
    let!(:balls) { %w[red blue].map { |color| FactoryBot.create(:ball, color: color) } }
    before do
      RailsAdmin.config ManagingUser do
        field :players
        field :balls
      end
    end

    it 'allows update' do
      visit edit_path(model_name: 'managing_user', id: user.id)
      expect(find("select#managing_user_player_names option[value=\"#{players[0].name}\"]")).to be_selected
      expect(find("select#managing_user_ball_ids option[value=\"#{balls[0].color}\"]")).to be_selected
      select(players[1].name, from: 'Players')
      select(balls[1].rails_admin_default_object_label_method, from: 'Balls')
      click_button 'Save'
      expect(ManagingUser.first.players).to match_array players
      expect(ManagingUser.first.balls).to match_array balls
    end
  end
end
