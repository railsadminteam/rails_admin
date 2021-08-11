require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Float do
  subject do
    RailsAdmin.config('FieldTest').fields.detect do |f|
      f.name == :float_field
    end.with(object: FieldTest.new)
  end

  describe '#html_attributes' do
    it 'should contain a step attribute' do
      expect(subject.html_attributes[:step]).to eq('any')
    end
  end

  describe '#view_helper' do
    it "uses the 'number' type input tag" do
      expect(subject.view_helper).to eq(:number_field)
    end
  end

  it_behaves_like 'a generic field type', :float_field, :float
end
