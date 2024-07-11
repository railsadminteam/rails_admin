

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::BsonObjectId do
  it_behaves_like 'a generic field type', :string_field, :bson_object_id

  describe '#parse_value' do
    let(:bson) { RailsAdmin::Adapters::Mongoid::Bson::OBJECT_ID.new }
    let(:field) do
      RailsAdmin.config(FieldTest).fields.detect do |f|
        f.name == :bson_object_id_field
      end
    end

    before :each do
      RailsAdmin.config do |config|
        config.model FieldTest do
          field :bson_object_id_field, :bson_object_id
        end
      end
    end

    it 'parse valid bson_object_id', mongoid: true do
      expect(field.parse_value(bson.to_s)).to eq bson
    end
  end
end
