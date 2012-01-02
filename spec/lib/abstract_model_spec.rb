require 'spec_helper'

describe 'AbstractModel' do
  describe "get!" do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }
    it 'raises exception if object cannot be retrieved' do
      lambda { abstract_model.get!('invalid-id') }.should raise_error(error=RailsAdmin::ObjectNotFound)
    end

    it 'returns abstract object on success' do
      player = Factory(:player)

      abstract_object = abstract_model.get!(player.id)
      abstract_object.object.should == player
    end
  end
end