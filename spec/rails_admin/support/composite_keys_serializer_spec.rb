# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Support::CompositeKeysSerializer do
  describe '.serialize' do
    it 'joins the key values the way ActiveRecord does' do
      expect(described_class.serialize([1, 2])).to eq '1_2'
      expect(described_class.serialize(%w[abc def])).to eq 'abc_def'
    end

    # The escaping changed, so this pins down that only key values holding a
    # delimiter -- which never round-tripped -- are written differently.
    it 'leaves a key value without a delimiter untouched' do
      expect(described_class.serialize(['a-b', 'c.d'])).to eq 'a-b_c.d'
    end
  end

  describe '.deserialize' do
    it 'splits the key values apart' do
      expect(described_class.deserialize('1_2')).to eq %w[1 2]
    end
  end

  describe 'a round trip' do
    [
      %w[1 2],
      ['a_b', 'c'],
      ['a', 'b_c'],
      ['a_', 'b'],
      ['a', '_b'],
      ['a~b', 'c'],
      ['~5F', 'c'],
      ['a__b', 'c_'],
    ].each do |keys|
      it "returns #{keys.inspect} unchanged" do
        expect(described_class.deserialize(described_class.serialize(keys))).to eq keys
      end
    end

    # Doubling the delimiter gave both of these the same string, so whichever
    # record was asked for, the other one is what came back.
    it 'tells apart keys that a doubled delimiter could not' do
      expect(described_class.serialize(%w[a_ b])).not_to eq described_class.serialize(%w[a _b])
    end
  end
end
