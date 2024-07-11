

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Uuid do
  let(:uuid) { SecureRandom.uuid }
  let(:object) { FactoryBot.create(:field_test) }
  let(:field) { RailsAdmin.config(FieldTest).fields.detect { |f| f.name == :uuid_field } }

  before do
    RailsAdmin.config do |config|
      config.model FieldTest do
        field :uuid_field, :uuid
      end
    end

    allow(object).to receive(:uuid_field).and_return uuid
    field.bindings = {object: object}
  end

  it 'field is a Uuid fieldtype' do
    expect(field.class).to eq RailsAdmin::Config::Fields::Types::Uuid
  end

  it 'handles uuid string' do
    expect(field.value).to eq uuid
  end

  it_behaves_like 'a generic field type', :string_field, :uuid
end
