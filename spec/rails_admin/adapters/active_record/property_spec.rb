require 'spec_helper'
require 'timecop'

describe 'RailsAdmin::Adapters::ActiveRecord::Property', active_record: true do
  describe 'string field' do
    subject { RailsAdmin::AbstractModel.new('Player').properties.detect { |f| f.name == :name } }

    it 'returns correct values' do
      expect(subject.pretty_name).to eq 'Name'
      expect(subject.type).to eq :string
      expect(subject.length).to eq 100
      expect(subject.nullable?).to be_false
      expect(subject.serial?).to be_false
    end
  end

  describe 'serialized field' do
    subject { RailsAdmin::AbstractModel.new('User').properties.detect { |f| f.name == :roles } }

    it 'returns correct values' do
      expect(subject.pretty_name).to eq 'Roles'
      expect(subject.type).to eq :serialized
      expect(subject.length).to eq 255
      expect(subject.nullable?).to be_true
      expect(subject.serial?).to be_false
    end
  end
end
