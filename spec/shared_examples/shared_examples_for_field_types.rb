

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

RSpec.shared_examples 'a string-like field type' do |column_name, _|
  subject do
    RailsAdmin.config('FieldTest').fields.detect do |f|
      f.name == column_name
    end.with(object: FieldTest.new)
  end

  it 'is a StringLike field' do
    expect(subject).to be_a(RailsAdmin::Config::Fields::Types::StringLike)
  end
end

RSpec.shared_examples 'a float-like field type' do |column_name|
  subject do
    RailsAdmin.config('FieldTest').fields.detect do |f|
      f.name == column_name
    end.with(object: FieldTest.new)
  end

  describe '#html_attributes' do
    it 'should contain a step attribute' do
      expect(subject.html_attributes[:step]).to eq('any')
    end

    it 'should contain a falsey required attribute' do
      expect(subject.html_attributes[:required]).to be_falsey
    end

    context 'when the field is required' do
      before do
        RailsAdmin.config FieldTest do
          field column_name, :float do
            required true
          end
        end
      end

      it 'should contain a truthy required attribute' do
        expect(subject.html_attributes[:required]).to be_truthy
      end
    end
  end

  describe '#view_helper' do
    it "uses the 'number' type input tag" do
      expect(subject.view_helper).to eq(:number_field)
    end
  end
end
