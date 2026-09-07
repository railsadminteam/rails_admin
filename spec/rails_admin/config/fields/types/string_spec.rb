# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::String do
  describe '#html_attributes' do
    before :each do
      RailsAdmin.config Ball do
        field 'color', :string
      end
    end

    let(:string_field) do
      RailsAdmin.config('Ball').fields.detect do |f|
        f.name == :color
      end.with(object: Ball.new)
    end

    it 'should contain a size attribute' do
      expect(string_field.html_attributes[:size]).to be_present
    end

    it 'should not contain a size attribute valorized with 0' do
      expect(string_field.html_attributes[:size]).to_not be_zero
    end
  end

  describe '#valid_length' do
    before :each do
      RailsAdmin.config Ball do
        field 'color', :string
      end
    end

    let(:string_field) do
      RailsAdmin.config('Ball').fields.detect { |f| f.name == :color }.with(object: Ball.new)
    end

    it 'ignores bounds given as a Proc (e.g. Devise password length validation)' do
      validator = ActiveModel::Validations::LengthValidator.new(
        attributes: [:color], minimum: -> { 6 }, maximum: -> { 128 },
      )
      allow(Ball).to receive(:validators_on).with(:color).and_return([validator])

      expect(string_field.valid_length).to eq({})
      expect { string_field.generic_help }.not_to raise_error
    end
  end

  it_behaves_like 'a generic field type', :string_field

  it_behaves_like 'a string-like field type', :string_field
end
