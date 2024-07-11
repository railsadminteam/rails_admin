

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Carrierwave do
  it_behaves_like 'a generic field type', :string_field, :carrierwave

  describe '#thumb_method' do
    before do
      RailsAdmin.config FieldTest do
        field :carrierwave_asset, :carrierwave
      end
    end

    let :rails_admin_field do
      RailsAdmin.config('FieldTest').fields.detect do |f|
        f.name == :carrierwave_asset
      end.with(
        object: FieldTest.new(string_field: 'dummy.txt'),
        view: ApplicationController.new.view_context,
      )
    end

    it 'auto-detects thumb-like version name' do
      expect(rails_admin_field.thumb_method).to eq :thumb
    end
  end
end
