

require 'spec_helper'
require 'base64'

RSpec.describe RailsAdmin::Config::Fields::Types::MultipleCarrierwave do
  it_behaves_like 'a generic field type', :string_field, :multiple_carrierwave

  describe '#thumb_method' do
    before do
      RailsAdmin.config FieldTest do
        field :carrierwave_assets, :multiple_carrierwave
      end
    end

    let :rails_admin_field do
      RailsAdmin.config('FieldTest').fields.detect do |f|
        f.name == :carrierwave_assets
      end.with(
        object: FieldTest.new(carrierwave_assets: [File.open(file_path('test.jpg'))]),
        view: ApplicationController.new.view_context,
      )
    end

    it 'auto-detects thumb-like version name' do
      expect(rails_admin_field.attachments.map(&:thumb_method)).to eq [:thumb]
    end
  end

  describe '#delete_value', active_record: true do
    before do
      RailsAdmin.config FieldTest do
        field :carrierwave_assets, :multiple_carrierwave
      end
    end
    let :file do
      CarrierWave::SanitizedFile.new(
        tempfile: StringIO.new(Base64.decode64('R0lGODlhAQABAIAAAAUEBAAAACwAAAAAAQABAAACAkQBADs=')),
        filename: 'dummy.gif',
      )
    end
    let :rails_admin_field do
      RailsAdmin.config('FieldTest').fields.detect do |f|
        f.name == :carrierwave_assets
      end.with(
        object: FieldTest.create(carrierwave_assets: [file]),
        view: ApplicationController.new.view_context,
      )
    end

    it 'does not use file.identifier, which is not available for Fog files' do
      expect_any_instance_of(CarrierWave::SanitizedFile).not_to receive :identifier
      expect(rails_admin_field.attachments.map(&:delete_value)).to eq ['dummy.gif']
    end
  end
end
