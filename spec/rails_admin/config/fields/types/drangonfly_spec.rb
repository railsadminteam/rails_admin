# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Dragonfly do
  it_behaves_like 'a generic field type', :string_field, :dragonfly

  let(:field) do
    RailsAdmin.config('FieldTest').fields.detect do |f|
      f.name == :dragonfly_asset
    end.with(object: record)
  end

  describe '#image?' do
    let(:file) { File.open(file_path('test.jpg')) }
    let(:record) { FactoryBot.create :field_test, dragonfly_asset: file }

    it 'returns true' do
      expect(field.image?).to be true
    end

    context 'with non-image' do
      let(:file) { File.open(file_path('test.txt')) }

      it 'returns false' do
        expect(field.image?).to be false
      end
    end
  end

  describe 'with a model which does not extend Dragonfly::Model' do
    before do
      class NonDragonflyTest < Tableless
        column :asset_uid, :varchar
      end
    end

    it 'does not break' do
      expect { RailsAdmin.config(NonDragonflyTest).fields }.not_to raise_error
    end
  end
end
