

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

  it_behaves_like 'a generic field type', :string_field

  it_behaves_like 'a string-like field type', :string_field
end
