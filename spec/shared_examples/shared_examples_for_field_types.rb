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
      subject do
        RailsAdmin.config('FieldTest').fields.detect do |f|
          f.name == column_name
        end.with(object: FieldTest.new)
      end

      it 'should contain a required attribute with the string "required" as value' do
        expect(subject.html_attributes[:required]).to be_truthy
      end
    end
  end
end

RSpec.shared_examples 'a string-ish field type' do |column_name, field_type|
  describe '#parse_input' do
    before do
      RailsAdmin.config FieldTest do
        field column_name, field_type
      end
    end
    subject do
      RailsAdmin.config('FieldTest').fields.detect do |f|
        f.name == column_name
      end.with(object: FieldTest.new)
    end

    context 'when value is empty' do
      let(:params) { {column_name => ''} }

      it 'makes the value nil' do
        subject.parse_input(params)
        expect(params.key?(column_name)).to be true
        expect(params[column_name]).to be nil
      end
    end

    context 'when value does not exist in params' do
      let(:params) { {} }

      it 'does not touch params' do
        subject.parse_input(params)
        expect(params.key?(column_name)).to be false
      end
    end
  end
end
