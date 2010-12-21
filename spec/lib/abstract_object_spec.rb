require 'spec_helper'

describe "AbstractObject" do
  describe "proxying" do
    let(:object) { mock("A mock") }
    let(:abstract_object) {  RailsAdmin::AbstractObject.new(object) }
  
    it "should act like a proxy" do
      object.should_receive(:method_call).once
    
      abstract_object.method_call
    end
  end
  
  describe "creating" do
    describe "a record with protected attributes and has_one association" do
      let(:player) { Player.new }
      let(:object) { RailsAdmin::AbstractObject.new player }
      let(:name) { "Stefan" }
      let(:number) { "87" }
      let(:position) { "Fifth baseman" }
      let(:suspended) { true }
      let(:draft) { Factory :draft }
      
      before do
        object.attributes = { :name => name, :number => number, :position => position, :suspended => suspended }
        object.associations = { :draft => draft.id, :team => nil }
      end
    
      it "should create a Player with given attributes" do
        object.save.should be_true
        
        player.reload
        player.name.should == name
        player.number.should == number.to_i
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
      let(:teams) { [Factory(:team)] }
      let(:divisions) { [] }
      
      before do
        Factory :team
        2.times { Factory :division }
        object.attributes = { :name  => name }
        object.associations = { :teams => teams.map(&:id), :division => divisions }
      end
      
      it "should create a League with given attributes and associations" do
        object.save.should be_true
        league.reload
        league.name.should == name
        league.divisions.should == divisions
        league.teams.should == teams
      end
    end
  end
end