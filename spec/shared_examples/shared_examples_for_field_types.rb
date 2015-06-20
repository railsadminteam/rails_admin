require 'spec_helper'

RSpec.shared_examples 'a generic field type' do |column_name, field_type|
  describe '#html_attributes' do
    context 'when the field is required' do
      before do
        RailsAdmin.config FieldTest do
          field column_name, field_type do
            required true
          end
        end
      end

      let :rails_admin_field do
        RailsAdmin.config('FieldTest').fields.detect do |f|
          f.name == column_name
        end.with(object: FieldTest.new)
      end

      it 'should contain a required attribute with the string "required" as value' do
        expect(rails_admin_field.html_attributes[:required]).to be_truthy
      end
    end
  end
end
