require 'spec_helper'
require 'rails_admin/adapters/mongoid/abstract_object'

describe "Mongoid::AbstractObject", :mongoid => true do
  before(:each) do
    @players = FactoryGirl.create_list :player, 3
    @team = RailsAdmin::Adapters::Mongoid::AbstractObject.new FactoryGirl.create :team
  end

  describe "references_many association" do
    it "supports retrieval of ids through foo_ids" do
      @team.player_ids.should == []
      player = FactoryGirl.create :player, :team => @team
      @team.player_ids.should == [player.id]
    end

    it "supports assignment of items through foo_ids=" do
      @team.players.should == []
      @team.player_ids = @players.map(&:id)
      @team.reload
      @team.players.map(&:id).should =~ @players.map(&:id)
    end

    it "skips invalid id on assignment through foo_ids=" do
      @team.player_ids = @players.map{|item| item.id.to_s }.unshift('4f431021dcf2310db7000006')
      @team.reload
      @players.each &:reload
      @team.players.map(&:id).should =~ @players.map(&:id)
    end
  end
end
