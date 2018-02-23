require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::SimpleMDE do
  describe 'asset locations' do
    before do
      @custom_prefix = '/foo'
      @default_prefix = Rails.application.config.assets.prefix
      Rails.application.config.assets.prefix = @custom_prefix
      RailsAdmin.config FieldTest do
        field :text_field, :simple_mde
      end
    end

    after do
      Rails.application.config.assets.prefix = @default_prefix
    end

    it 'allows custom assets prefix for js' do
      expect(
        RailsAdmin.config(FieldTest).fields.detect { |f| f.name == :text_field }.with(object: FieldTest.new).js_location[0..(@custom_prefix.length - 1)],
      ).to eq @custom_prefix
    end

    it 'allows custom assets prefix for css' do
      expect(
        RailsAdmin.config(FieldTest).fields.detect { |f| f.name == :text_field }.with(object: FieldTest.new).css_location[0..(@custom_prefix.length - 1)],
      ).to eq @custom_prefix
    end
  end

  it_behaves_like 'a generic field type', :text_field, :simple_mde
end
