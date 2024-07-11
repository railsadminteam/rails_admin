

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Date do
  it_behaves_like 'a generic field type', :date_field, :date

  describe '#formatted_value' do
    it 'gets object value' do
      field = RailsAdmin.config(FieldTest).fields.detect do |f|
        f.name == :date_field
      end.with(object: FieldTest.new(date_field: DateTime.parse('02/01/2012')))

      expect(field.formatted_value).to eq 'January 02, 2012'
    end

    it 'gets default value for new objects if value is nil' do
      RailsAdmin.config(FieldTest) do |_config|
        field :date_field do
          default_value DateTime.parse('01/01/2012')
        end
      end

      field = RailsAdmin.config(FieldTest).fields.detect do |f|
        f.name == :date_field
      end.with(object: FieldTest.new)

      expect(field.formatted_value).to eq 'January 01, 2012'
    end
  end

  describe '#parse_input' do
    let(:field) { RailsAdmin.config(FieldTest).fields.detect { |f| f.name == :date_field } }

    before :each do
      @object = FactoryBot.create(:field_test)
      @time = ::Time.now.getutc
    end

    after :each do
      Time.zone = 'UTC'
    end

    it 'reads %B %d, %Y by default' do
      @object.date_field = field.parse_input(date_field: @time.strftime('%B %d, %Y'))
      expect(@object.date_field).to eq(::Date.parse(@time.to_s))
    end

    it 'covers a timezone lag even if in UTC+n:00 timezone.' do
      Time.zone = 'Tokyo' # +09:00

      @object.date_field = field.parse_input(date_field: @time.strftime('%B %d, %Y'))
      expect(@object.date_field).to eq(::Date.parse(@time.to_s))
    end

    it 'has a simple customization option' do
      RailsAdmin.config FieldTest do
        field :date_field do
          date_format do
            :default
          end
        end
      end

      @object.date_field = field.parse_input(date_field: @time.strftime('%Y-%m-%d'))
      expect(@object.date_field).to eq(::Date.parse(@time.to_s))
    end

    it 'has a customization option' do
      RailsAdmin.config FieldTest do
        field :date_field do
          strftime_format '%Y/%m/%d'
        end
      end

      @object.date_field = field.parse_input(date_field: @time.strftime('%Y/%m/%d'))
      expect(@object.date_field).to eq(::Date.parse(@time.to_s))
    end
  end

  describe '#default_value' do
    let(:field) do
      field = RailsAdmin.config(FieldTest).fields.detect { |f| f.name == :date_field }
      field.bindings = {object: @object}
      field
    end

    before :each do
      RailsAdmin.config FieldTest do
        field :date_field do
          default_value Date.current
        end
      end
      @object = FactoryBot.create(:field_test)
      @time = ::Time.now.getutc
    end

    it 'should contain the default value' do
      expect(field.default_value).to eq(Date.current)
    end

    it 'should propagate to the field formatted_value when the object is a new record' do
      object = FactoryBot.build(:field_test)
      field.bindings = {object: object}
      expect(field.formatted_value).to eq(Date.current.strftime('%B %d, %Y'))
    end
  end
end
