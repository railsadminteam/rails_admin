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

      FactoryGirl.create :player, name: 'なまえ'
    end

    let(:objects) { Player.all }
    let(:schema) { {only: [:number, :name]} }

    subject { RailsAdmin::CSVConverter.new(objects, schema).to_csv({encoding_to: encoding}) }

    context 'encoding to UTF-8' do
      let(:encoding) { 'UTF-8' }

      it 'should export to UTR-8 with BOM' do
        expect(subject[1]).to eq 'UTF-8'
        expect(subject[2].encoding).to eq Encoding::UTF_8
        expect(subject[2]).to match(/\A\xEF\xBB\xBF/)  # have BOM
      end
    end

    context 'encoding to Shift_JIS' do
      let(:encoding) { 'Shift_JIS' }

      it 'should export to Shift_JIS' do
        expect(subject[1]).to eq 'Shift_JIS'
        expect(subject[2].encoding).to eq Encoding::Shift_JIS
      end
    end

  end
end
