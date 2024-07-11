

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Numeric do
  it_behaves_like 'a generic field type', :integer_field, :integer

  subject do
    RailsAdmin.config('FieldTest').fields.detect do |f|
      f.name == :integer_field
    end.with(object: FieldTest.new)
  end

  describe '#view_helper' do
    it "uses the 'number' type input tag" do
      expect(subject.view_helper).to eq(:number_field)
    end
  end
end
