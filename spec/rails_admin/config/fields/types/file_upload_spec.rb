require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::FileUpload do
  it_behaves_like 'a generic field type', :string_field, :file_upload

  describe '#html_attributes' do
    context 'when the field is required and value is already set' do
      before do
        RailsAdmin.config FieldTest do
          field :string_field, :file_upload do
            required true
          end
        end
      end

      let :rails_admin_field do
        RailsAdmin.config('FieldTest').fields.detect do |f|
          f.name == :string_field
        end.with(object: FieldTest.new(string_field: 'dummy.jpg'))
      end

      it 'does not have a required attribute' do
        expect(rails_admin_field.html_attributes[:required]).to be_falsy
      end
    end
  end
end
