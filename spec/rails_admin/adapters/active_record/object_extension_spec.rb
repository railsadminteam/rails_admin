# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'RailsAdmin::Adapters::ActiveRecord::ObjectExtension', active_record: true do
  describe '#assign_attributes' do
    let(:player) { Player.new }
    let(:object) { player.extend RailsAdmin::Adapters::ActiveRecord::ObjectExtension }

    it 'does not cause error with nil' do
      expect(object.assign_attributes(nil)).to be nil
    end
  end

  describe 'has_one association' do
    let(:draft) { FactoryBot.create(:draft) }
    let(:player) { FactoryBot.build(:player).extend(RailsAdmin::Adapters::ActiveRecord::ObjectExtension) }
    before do
      class PlayerWithAutoSave < Player
        has_one :draft, inverse_of: :player, foreign_key: :player_id, autosave: true
      end
    end

    it 'provides id getter' do
      player.draft = draft
      expect(player.draft_id).to eq draft.id
    end

    context 'on create' do
      before do
        player.draft_id = draft.id
        expect(player.draft).to receive(:save).once.and_call_original
        player.save
      end

      it 'persists associated documents changes on save' do
        expect(player.reload.draft).to eq draft
      end
    end

    context 'on update' do
      let(:player) { FactoryBot.create(:player).extend(RailsAdmin::Adapters::ActiveRecord::ObjectExtension) }
      before do
        player.draft_id = draft.id
      end

      it 'persists associated documents changes on assignment' do
        expect(player.reload.draft).to eq draft
      end
    end

    context 'with explicit id setter' do
      let(:user) { ManagingUser.create(FactoryBot.attributes_for(:user)) }
      let(:team) { ManagedTeam.create(FactoryBot.attributes_for(:team)) }

      it 'works without issues' do
        user.team_id = team.id
        expect(user.reload.team).to eq team
      end
    end

    context 'when associated class has custom primary key' do
      let(:league) { FactoryBot.build(:league).extend(RailsAdmin::Adapters::ActiveRecord::ObjectExtension) }
      let(:division) { FactoryBot.create :division }

      it 'does not break' do
        league.division_id = division.id
        league.save!
        expect(league.reload.division).to eq division
      end
    end
  end
end
