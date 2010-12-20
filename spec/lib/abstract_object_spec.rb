require 'spec_helper'

describe "AbstractObject" do
  let(:object) { mock("A mock") }
  let(:abstract_object) {  RailsAdmin::AbstractObject.new(object) }
  
  it "should act like a proxy" do
    object.should_receive(:method_call).once
    
    abstract_object.method_call
  end
end