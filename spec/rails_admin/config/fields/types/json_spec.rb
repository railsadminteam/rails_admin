require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Json do
  let(:field) { RailsAdmin.config(FieldTest).fields.detect { |f| f.name == :json_field } }

  describe '#parse_input' do
    before :each do
      RailsAdmin.config do |config|
        config.model FieldTest do
          field :json_field, :json
        end
      end
    end

    it 'parse valid json string' do
      data = {string: 'string', integer: 1, array: [1, 2, 3], object: {bla: 'foo'}}.as_json
      expect(field.parse_input(json_field: data.to_json)).to eq data
    end

    it 'raise JSON::ParserError with invalid json string' do
      expect { field.parse_input(json_field: '{{') }.to raise_error(JSON::ParserError)
    end
  end

  describe 'aliasing' do
    before :each do
      RailsAdmin.config do |config|
        config.model FieldTest do
          field :json_field, :jsonb
        end
      end
    end

    it 'allows use of :jsonb fieldtype' do
      expect(field.class).to eq RailsAdmin::Config::Fields::Types::Json
    end
  end

  it_behaves_like 'a generic field type', :text, :json
end
