# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Serialized do
  it_behaves_like 'a generic field type', :text_field, :serialized

  subject { RailsAdmin.config(User).field(:roles, :serialized) }

  describe '#formatted_value' do
    it 'dumps the value as YAML' do
      user = User.new(roles: %w[admin])

      expect(subject.with(object: user).formatted_value).to eq "---\n- admin\n"
    end

    context 'with a store of ActiveRecord', active_record: true do
      it 'leaves the class wrapping the value out of the text' do
        stub_const('StoreTest', Class.new(FieldTest) do
          store :text_field, accessors: %i[foo], coder: YAML
        end)
        record = StoreTest.new(foo: 'bar')
        field = RailsAdmin.config(StoreTest).field(:text_field, :serialized)

        expect(record.text_field).to be_a ActiveSupport::HashWithIndifferentAccess
        expect(field.with(object: record).formatted_value).to eq "---\nfoo: bar\n"
      end
    end

    context 'with a document of Mongoid', mongoid: true do
      it 'leaves its class out of the text as well' do
        field_test = FieldTest.create!(hash_field: {'a' => 1, 'nested' => {'b' => 2}})
        value = FieldTest.find(field_test.id).hash_field
        field = RailsAdmin.config(FieldTest).field(:hash_field)

        expect(value).to be_a BSON::Document
        expect(field.with(object: field_test).formatted_value).to eq "---\na: 1\nnested:\n  b: 2\n"
      end
    end
  end

  describe '#parse_value' do
    it 'reads back the scalars YAML has of its own' do
      expect(subject.parse_value("---\n- :admin\n- 2026-01-01\n")).to eq [:admin, Date.new(2026, 1, 1)]
    end

    it 'refuses anything carrying a class name' do
      expect { subject.parse_value(YAML.dump(Object.new)) }.to raise_error Psych::DisallowedClass
    end
  end
end
