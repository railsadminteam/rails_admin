require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::MultipleCarrierwave do
  it_behaves_like 'a generic field type', :string_field, :multiple_carrierwave

  describe '#thumb_method' do
    before do
      allow_any_instance_of(CarrierwaveUploader).to receive(:cache!)
      RailsAdmin.config FieldTest do
        field :carrierwave_assets, :multiple_carrierwave
      end
    end

    let :rails_admin_field do
      RailsAdmin.config('FieldTest').fields.detect do |f|
        f.name == :carrierwave_assets
      end.with(
        object: FieldTest.new(carrierwave_assets: ['dummy.txt']),
        view: ApplicationController.new.view_context,
      )
    end

    it 'auto-detects thumb-like version name' do
      expect(rails_admin_field.attachments.map(&:thumb_method)).to eq [:thumb]
    end
  end
end
