require 'spec_helper'

describe "AbstractObject" do
  describe "proxy" do
    let(:object) { mock("A mock") }
    let(:abstract_object) {  RailsAdmin::AbstractObject.new(object) }

    it "should act like a proxy" do
      object.should_receive(:method_call).once

      abstract_object.method_call
    end
  end

  describe "create" do
    let(:player) { Player.new }
    let(:object) { RailsAdmin::AbstractObject.new player }
    let(:name) { "Stefan Kiszonka" }
    let(:number) { 87 }
    let(:position) { "Fifth baseman" }
    let(:suspended) { true }

    describe "a record without associations" do
      before do
        object.attributes = { :name => name, :number => number, :position => position, :suspended => suspended, :team_id => nil }
      end

      it "should create a Player with given attributes" do
        object.save.should be_true

        player.reload
        player.name.should == name
        player.number.should == number
        player.position.should == position
        player.suspended.should == suspended
        player.draft.should == nil
        player.team.should == nil
      end
    end

    describe "a record with protected attributes and has_one association" do
      let(:draft) { Draft.create(:date => 1.week.ago, :round => 1, :pick => 1, :overall => 1, :team_id => -1, :player_id => -1) }

      before do
        object.attributes = { :name => name, :number => number, :position => position, :suspended => suspended, :team_id => nil }
        object.associations = { :draft => draft.id }
      end

      it "should create a Player with given attributes" do
        object.save.should be_true

        player.reload
        player.name.should == name
        player.number.should == number
        player.position.should == position
        player.suspended.should == suspended
        player.draft.should == draft.reload
        player.team.should == nil
      end
    end

    describe "a record with has_many associations" do
      let(:league) { League.new }
      let(:object) { RailsAdmin::AbstractObject.new league }
      let(:name) { "Awesome League" }
      let(:divisions) { [Division.create(:name => "D1", :league_id => -1), Division.create(:name => "D2", :league_id => -1)] }

      before do
        object.attributes = { :name  => name }
        object.associations = { :divisions => divisions }
      end

      it "should create a League with given attributes and associations" do
        object.save.should be_true
        league.reload
        league.name.should == name
        league.divisions.should == divisions
      end
    end
  end

  describe "update" do
    describe "a record with protected attributes and has_one association" do
      let(:name) { "Stefan Koza" }
      let(:suspended) { true }
      let(:player) { Player.create(:suspended => true, :number => 42, :name => name) }
      let(:object) { RailsAdmin::AbstractObject.new player }
      let(:new_team) { Team.create(:name => "T1", :manager => "M1", :founded => 1, :wins => 1, :losses => 1, :win_percentage => 1, :division_id => -1) }
      let(:new_suspended) { false }
      let(:new_draft) { nil }
      let(:new_number) { player.number + 29 }

      before do
        object.attributes = { :number => new_number, :team_id => new_team.id, :suspended => new_suspended }
        object.associations = { :draft => new_draft }
        object.save
      end

      it "should update a record and associations" do
        object.reload
        object.number.should == new_number
        object.name.should == name
        object.draft.should == nil
        object.suspended.should == new_suspended
        object.team.should == new_team
      end
    end
  end

  describe "destroy" do
    let(:player) { Player.create(:name => "P1") }
    let(:object) { RailsAdmin::AbstractObject.new player }

    before do
      object.destroy
    end

    it "should delete the record" do
      Player.exists?(player.id).should == false
    end
  end
end
