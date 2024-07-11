

require 'spec_helper'

RSpec.describe 'RailsAdmin::Adapters::Mongoid::Property', mongoid: true do
  subject { RailsAdmin::AbstractModel.new(FieldTest).properties.detect { |p| p.name == field } }

  describe '_id field' do
    let(:field) { :_id }

    it 'has correct values' do
      expect(subject.pretty_name).to eq ' id'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_truthy
      expect(subject.type).to eq :bson_object_id
      expect(subject.length).to be_nil
    end
  end

  describe 'array field' do
    let(:field) { :array_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Array field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :serialized
      expect(subject.length).to be_nil
    end
  end

  describe 'big decimal field' do
    let(:field) { :big_decimal_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Big decimal field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :decimal
      expect(subject.length).to be_nil
    end
  end

  describe 'boolean field' do
    let(:field) { :boolean_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Boolean field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :boolean
      expect(subject.length).to be_nil
    end
  end

  describe 'bson object id field' do
    let(:field) { :bson_object_id_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Bson object id field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :bson_object_id
      expect(subject.length).to be_nil
    end
  end

  describe 'date field' do
    let(:field) { :date_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Date field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :date
      expect(subject.length).to be_nil
    end
  end

  describe 'datetime field' do
    let(:field) { :datetime_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Datetime field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :datetime
      expect(subject.length).to be_nil
    end
  end

  describe 'time with zone field' do
    let(:field) { :time_with_zone_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Time with zone field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :datetime
      expect(subject.length).to be_nil
    end
  end

  describe 'default field' do
    let(:field) { :default_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Default field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :string
      expect(subject.length).to eq 255
    end
  end

  describe 'float field' do
    let(:field) { :float_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Float field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :float
      expect(subject.length).to be_nil
    end
  end

  describe 'hash field' do
    let(:field) { :hash_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Hash field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :serialized
      expect(subject.length).to be_nil
    end
  end

  describe 'integer field' do
    let(:field) { :integer_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Integer field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :integer
      expect(subject.length).to be_nil
    end
  end

  describe 'object field' do
    let(:field) { :object_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Object field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :string
      expect(subject.length).to eq 255
    end
  end

  describe 'string field' do
    let(:field) { :string_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'String field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :text
      expect(subject.length).to be_nil
    end
  end

  describe 'symbol field' do
    let(:field) { :symbol_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Symbol field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :string
      expect(subject.length).to eq 255
    end
  end

  describe 'time field' do
    let(:field) { :time_field }

    it 'has correct values' do
      expect(subject.pretty_name).to eq 'Time field'
      expect(subject.nullable?).to be_truthy
      expect(subject.serial?).to be_falsey
      expect(subject.type).to eq :datetime
      expect(subject.length).to be_nil
    end
  end

  describe 'aliased field' do
    let(:field) { :aliased_field }

    it 'has correct values' do
      expect(subject.name).to eq :aliased_field
      expect(subject.pretty_name).to eq 'Aliased field'
    end
  end

  describe '#length_validation_lookup' do
    it 'detects validation length properly' do
      class LengthValiated
        include Mongoid::Document
        field :text, type: String
        validates :text, length: {maximum: 50}
      end
      expect(RailsAdmin::AbstractModel.new('LengthValiated').properties.last.send(:length_validation_lookup)).to eq(50)
    end

    it 'does not cause problem with custom validators' do
      class MyCustomValidator < ActiveModel::Validator
        def validate(_r); end
      end

      class CustomValiated
        include Mongoid::Document
        field :text, type: String
        validates_with MyCustomValidator
      end
      expect { RailsAdmin::AbstractModel.new('CustomValiated').properties.last.send(:length_validation_lookup) }.not_to raise_error
    end
  end

  describe '#read_only?' do
    before do
      class HasReadOnlyColumn
        include Mongoid::Document
        field :name, type: String
        attr_readonly :name
      end
    end

    it 'returns correct values' do
      expect(RailsAdmin::AbstractModel.new('Player').properties.detect { |f| f.name == :name }).not_to be_read_only
      expect(RailsAdmin::AbstractModel.new('HasReadOnlyColumn').properties.detect { |f| f.name == :name }).to be_read_only
    end
  end
end
