require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Datetime do
  describe 'formatted_date_value' do
    it 'gets object value' do
      expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name ==:datetime_field}.with(object: FieldTest.new(datetime_field: DateTime.parse('02/01/2012'))).formatted_date_value).to eq 'January 02, 2012'
    end

    it 'gets default value for new objects if value is nil' do
      RailsAdmin.config(FieldTest) do |config|
        field :datetime_field do
          default_value DateTime.parse('01/01/2012')
        end
      end
      expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name ==:datetime_field}.with(object: FieldTest.new).formatted_date_value).to eq 'January 01, 2012'
    end
  end
end
