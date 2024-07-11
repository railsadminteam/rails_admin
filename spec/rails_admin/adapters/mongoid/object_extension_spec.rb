

require 'spec_helper'

RSpec.describe 'RailsAdmin::Adapters::Mongoid::ObjectExtension', mongoid: true do
  describe 'has_many association' do
    let(:players) { FactoryBot.create_list :player, 2 }
    before do
      class TeamWithAutoSave < Team
        has_many :players, inverse_of: :team, autosave: true
      end
    end

    context 'on create' do
      before do
        team.player_ids = players.collect(&:id)
        team.players.each { |player| expect(player).to receive(:save).once.and_call_original }
        team.save
      end

      context 'with autosave: false' do
        let(:team) { FactoryBot.build(:team).extend(RailsAdmin::Adapters::Mongoid::ObjectExtension) }

        it 'persists associated documents changes on save' do
          expect(team.reload.players).to match_array players
        end
      end

      context 'with autosave: true' do
        let(:team) { TeamWithAutoSave.new(FactoryBot.attributes_for(:team)).extend(RailsAdmin::Adapters::Mongoid::ObjectExtension) }

        it 'persists associated documents changes on save' do
          expect(team.reload.players).to match_array players
        end
      end
    end

    context 'on update' do
      let(:team) { FactoryBot.create(:team).extend(RailsAdmin::Adapters::Mongoid::ObjectExtension) }
      before do
        team.player_ids = players.collect(&:id)
      end

      context 'with autosave: false' do
        let(:team) { FactoryBot.create(:team).extend(RailsAdmin::Adapters::Mongoid::ObjectExtension) }

        it 'persists associated documents changes on assignment' do
          expect(team.reload.players).to match_array players
        end
      end

      context 'with autosave: true' do
        let(:team) { TeamWithAutoSave.create(FactoryBot.attributes_for(:team)).extend(RailsAdmin::Adapters::Mongoid::ObjectExtension) }

        it 'persists associated documents changes on assignment' do
          expect(team.reload.players).to match_array players
        end
      end
    end
  end

  describe 'has_one association' do
    let(:draft) { FactoryBot.create(:draft) }
    before do
      class PlayerWithAutoSave < Player
        has_one :draft, inverse_of: :player, autosave: true
      end
    end

    context 'on create' do
      before do
        player.draft = draft
        expect(player.draft._target).to receive(:save).once.and_call_original
        player.save
      end

      context 'with autosave: false' do
        let(:player) { FactoryBot.build(:player).extend(RailsAdmin::Adapters::Mongoid::ObjectExtension) }

        it 'persists associated documents changes on save' do
          expect(player.reload.draft).to eq draft
        end
      end

      context 'with autosave: true' do
        let(:player) { PlayerWithAutoSave.new(FactoryBot.attributes_for(:player)).extend(RailsAdmin::Adapters::Mongoid::ObjectExtension) }

        it 'persists associated documents changes on save' do
          expect(player.reload.draft).to eq draft
        end
      end
    end

    context 'on update' do
      before do
        player.draft = draft
      end

      context 'with autosave: false' do
        let(:player) { FactoryBot.create(:player).extend(RailsAdmin::Adapters::Mongoid::ObjectExtension) }

        it 'persists associated documents changes on assignment' do
          expect(player.reload.draft).to eq draft
        end
      end

      context 'with autosave: true' do
        let(:player) { PlayerWithAutoSave.create(FactoryBot.attributes_for(:player)).extend(RailsAdmin::Adapters::Mongoid::ObjectExtension) }

        it 'persists associated documents changes on assignment' do
          expect(player.reload.draft).to eq draft
        end
      end
    end
  end
end
