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
    let(:player) { Player.new }
    let(:object) { RailsAdmin::AbstractObject.new player }
    let(:name) { "Stefan" }
    let(:number) { "87" }
    let(:position) { "Fifth baseman" }
    
    before do
      player.attributes = { :name => name, :number => number, :position => position }
      player.save
    end
    
    it "should create a Player with given attributes" do
      player = Player.first
      player.name.should == name
      player.number.should == number.to_i
      player.position.should == position
    end
  end
end