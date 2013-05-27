require 'spec_helper'
require 'rails_admin/adapters/mongoid/abstract_object'

describe "RailsAdmin::Adapters::Mongoid::AbstractObject", :mongoid => true do
  before(:each) do
    @players = FactoryGirl.create_list :player, 3
    @draft = FactoryGirl.create :draft
    @team = RailsAdmin::Adapters::Mongoid::AbstractObject.new FactoryGirl.create :team
  end

  describe "references_many association" do
    it "supports retrieval of ids through foo_ids" do
      expect(@team.player_ids).to eq([])
      player = FactoryGirl.create :player, :team => @team
      expect(@team.player_ids).to eq([player.id])
    end

    it "supports assignment of items through foo_ids=" do
      expect(@team.players).to eq([])
      @team.player_ids = @players.map(&:id)
      @team.reload
      expect(@team.players.map(&:id)).to match_array @players.map(&:id)
    end

    it "skips invalid id on assignment through foo_ids=" do
      @team.player_ids = @players.map{|item| item.id.to_s }.unshift('4f431021dcf2310db7000006')
      @team.reload
      @players.each &:reload
      expect(@team.players.map(&:id)).to match_array @players.map(&:id)
    end

    describe "model's custom setter" do
      before do
        Team.class_eval do
          def player_ids= players_ids
            self.custom_field = players_ids * ', '
          end
        end
      end

      after do
        Team.class_eval do
          undef player_ids=
        end
      end

      it "have been called" do
        expect(@team.custom_field).to eq(nil)
        @team.player_ids = @players.map(&:id)
        expect(@team.custom_field).to eq(@players.map(&:id) * ', ')
      end
    end
  end

  describe "references_one association" do
    describe "model's custom setter" do
      before do
        Team.class_eval do
          def draft_id= draft_id
            self.custom_field = draft_id.to_s
          end
        end
      end

      after do
        Team.class_eval do
          undef draft_id=
        end
      end

      it "have been called" do
        expect(@team.custom_field).to eq(nil)
        @team.draft_id = @draft.id
        expect(@team.custom_field).to eq(@draft.id.to_s)
      end
    end
  end
end
