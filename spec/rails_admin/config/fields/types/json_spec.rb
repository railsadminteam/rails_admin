require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Json do
  describe '#parse_input' do
    let(:field) { RailsAdmin.config(FieldTest).fields.detect { |f| f.name == :json_field } }
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
end
