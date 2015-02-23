# encoding: utf-8

require 'spec_helper'

describe RailsAdmin::CSVConverter do
  it 'keeps headers ordering' do
    RailsAdmin.config(Player) do
      export do
        field :number
        field :name
      end
    end

    FactoryGirl.create :player
    objects = Player.all
    schema = {only: [:number, :name]}
    expect(RailsAdmin::CSVConverter.new(objects, schema).to_csv({})[2]).to match(/Number,Name/)
  end

  describe '#to_csv' do
    before do
      RailsAdmin.config(Player) do
        export do
          field :number
          field :name
        end
      end
    end

    let(:objects) { FactoryGirl.create_list :player, 1, number: 1, name: 'なまえ' }
    let(:schema) { {only: [:number, :name]} }

    subject { RailsAdmin::CSVConverter.new(objects, schema).to_csv(encoding_to: encoding) }

    context 'when encoding to UTF-8' do
      let(:encoding) { 'UTF-8' }

      it 'exports to UTR-8 with BOM' do
        expect(subject[1]).to eq 'UTF-8'
        expect(subject[2].encoding).to eq Encoding::UTF_8
        expect(subject[2].unpack('H*').first).
          to eq 'efbbbf4e756d6265722c4e616d650a312ce381aae381bee381880a'  # have BOM
      end
    end

    context 'when encoding to Shift_JIS' do
      let(:encoding) { 'Shift_JIS' }

      it 'exports to Shift_JIS' do
        expect(subject[1]).to eq 'Shift_JIS'
        expect(subject[2].encoding).to eq Encoding::Shift_JIS
        expect(subject[2].unpack('H*').first).
          to eq '4e756d6265722c4e616d650a312c82c882dc82a60a'
      end
    end

    context 'when encoding to UTF-16(ASCII-incompatible)' do
      let(:encoding) { 'UTF-16' }

      it 'encodes to expected byte sequence' do
        expect(subject[1]).to eq 'UTF-16'
        expect(subject[2].encoding).to eq Encoding::UTF_16
        expect(subject[2].unpack('H*').first.force_encoding('US-ASCII')).
          to eq 'feff004e0075006d006200650072002c004e0061006d0065000a0031002c306a307e3048000a'
      end
    end
  end
end
