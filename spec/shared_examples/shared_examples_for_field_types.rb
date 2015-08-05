require 'spec_helper'

RSpec.shared_examples 'a generic field type' do |column_name, field_type|
  context 'with browser_validations' do
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

    context 'enabled' do
      before :each do
        RailsAdmin::Config.browser_validations = true
      end

      describe '#html_attributes' do
        it 'should contain a required attribute with the string "required" as value' do
          expect(rails_admin_field.html_attributes[:required]).to be_truthy
        end
      end
    end

    context 'disabled' do
      before :each do
        RailsAdmin::Config.browser_validations = false
      end

      describe '#html_attributes' do
        it 'should contain a required attribute with the string "required" as value' do
          expect(rails_admin_field.html_attributes[:required]).to be_falsey
        end
      end
    end
  end
end
