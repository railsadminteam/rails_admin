# frozen_string_literal: true

require 'spec_helper'

# Saving a document that was built with children on a non-autosave has_many or
# has_one takes two passes, because the children have nothing to point at until
# the parent has an id. This used to be done by extending each record with an
# after_create callback, which made the record undumpable -- Marshal refuses an
# object with a singleton.
RSpec.describe 'RailsAdmin::Adapters::Mongoid::Repository', mongoid: true do
  let(:abstract_model) { RailsAdmin::AbstractModel.new('Team') }
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
        abstract_model.save(team)
      end

      context 'with autosave: false' do
        let(:team) { FactoryBot.build(:team) }

        it 'persists associated documents changes on save' do
          expect(team.reload.players).to match_array players
        end
      end

      context 'with autosave: true' do
        let(:team) { TeamWithAutoSave.new(FactoryBot.attributes_for(:team)) }

        it 'persists associated documents changes on save' do
          expect(team.reload.players).to match_array players
        end
      end
    end

    context 'on update' do
      let(:team) { FactoryBot.create(:team) }
      before do
        team.player_ids = players.collect(&:id)
      end

      context 'with autosave: false' do
        let(:team) { FactoryBot.create(:team) }

        it 'persists associated documents changes on assignment' do
          expect(team.reload.players).to match_array players
        end
      end

      context 'with autosave: true' do
        let(:team) { TeamWithAutoSave.create(FactoryBot.attributes_for(:team)) }

        it 'persists associated documents changes on assignment' do
          expect(team.reload.players).to match_array players
        end
      end
    end
  end

  describe 'has_one association' do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }
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
        abstract_model.save(player)
      end

      context 'with autosave: false' do
        let(:player) { FactoryBot.build(:player) }

        it 'persists associated documents changes on save' do
          expect(player.reload.draft).to eq draft
        end
      end

      context 'with autosave: true' do
        let(:player) { PlayerWithAutoSave.new(FactoryBot.attributes_for(:player)) }

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
        let(:player) { FactoryBot.create(:player) }

        it 'persists associated documents changes on assignment' do
          expect(player.reload.draft).to eq draft
        end
      end

      context 'with autosave: true' do
        let(:player) { PlayerWithAutoSave.create(FactoryBot.attributes_for(:player)) }

        it 'persists associated documents changes on assignment' do
          expect(player.reload.draft).to eq draft
        end
      end
    end
  end
end
