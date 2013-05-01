require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Text do
  describe 'ckeditor_base_location' do
    it 'allows custom assets prefix' do
      custom_prefix = '/foo'
      Rails.application.config.assets.prefix = custom_prefix
      expect(
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :text_field}.with(object: FieldTest.new).ckeditor_base_location[0..(custom_prefix.length-1)]
      ).to eq custom_prefix
    end
  end
end
