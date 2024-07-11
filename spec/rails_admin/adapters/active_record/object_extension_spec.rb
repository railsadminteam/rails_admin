

require 'spec_helper'

RSpec.describe 'RailsAdmin::Adapters::ActiveRecord::ObjectExtension', active_record: true do
  describe '#assign_attributes' do
    let(:player) { Player.new }
    let(:object) { player.extend RailsAdmin::Adapters::ActiveRecord::ObjectExtension }

    it 'does not cause error with nil' do
      expect(object.assign_attributes(nil)).to be nil
    end
  end
end
