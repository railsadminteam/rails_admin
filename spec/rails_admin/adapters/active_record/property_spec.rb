

require 'spec_helper'
require 'timecop'

RSpec.describe 'RailsAdmin::Adapters::ActiveRecord::Property', active_record: true do
  describe 'string field' do
    subject { RailsAdmin::AbstractModel.new('Player').properties.detect { |f| f.name == :name } }

    it 'returns correct values' do
      expect(subject.pretty_name).to eq 'Name'
      expect(subject.type).to eq :string
      expect(subject.length).to eq 100
      expect(subject.nullable?).to be_falsey
      expect(subject.serial?).to be_falsey
    end
  end

  describe 'serialized field' do
    subject { RailsAdmin::AbstractModel.new('User').properties.detect { |f| f.name == :roles } }

    it 'returns correct values' do
      expect(subject.pretty_name).to eq 'Roles'
      expect(subject.type).to eq :serialized
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
    end
  end

  describe '#read_only?' do
    before do
      class HasReadOnlyColumn < Tableless
        column :name, :varchar
        attr_readonly :name
      end
    end

    it 'returns correct values' do
      expect(RailsAdmin::AbstractModel.new('Player').properties.detect { |f| f.name == :name }).not_to be_read_only
      expect(RailsAdmin::AbstractModel.new('HasReadOnlyColumn').properties.detect { |f| f.name == :name }).to be_read_only
    end
  end
end
