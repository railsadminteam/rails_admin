require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Datetime do
  describe "#parse_input" do
    before :each do
      @field = RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :datetime_field }
      @object = FactoryGirl.create(:field_test)
      @time = ::Time.now.getutc
    end

    after :each do
      Time.zone = 'UTC'
    end

    it "is able to read %B %d, %Y %H:%M" do
      @object = FactoryGirl.create(:field_test)
      @object.datetime_field = @field.parse_input({ :datetime_field => @time.strftime("%B %d, %Y %H:%M") })
      expect(@object.datetime_field.strftime("%Y-%m-%d %H:%M")).to eq(@time.strftime("%Y-%m-%d %H:%M"))
    end

    it "is able to read %a, %d %b %Y %H:%M:%S" do
      RailsAdmin.config FieldTest do
        edit do
          field :datetime_field do
            date_format :default
          end
        end
      end
      @object = FactoryGirl.create(:field_test)
      @object.datetime_field = @field.parse_input({ :datetime_field => @time.strftime("%a, %d %b %Y %H:%M:%S") })
      expect(@object.datetime_field.to_s(:rfc822)).to eq(@time.to_s(:rfc822))
    end

    it "has a customization option" do
      RailsAdmin.config FieldTest do
        list do
          field :datetime_field do
            strftime_format "%Y-%m-%d %H:%M:%S"
          end
        end
      end
      @object = FactoryGirl.create(:field_test)
      @object.datetime_field = @field.parse_input({ :datetime_field => @time.strftime("%Y-%m-%d %H:%M:%S") })
      expect(@object.datetime_field.to_s(:rfc822)).to eq(@time.to_s(:rfc822))
    end

    it "does round-trip saving properly with non-UTC timezones" do
      Time.zone = 'Vienna'
      @object = FactoryGirl.create(:field_test)
      @object.datetime_field = @field.parse_input({ :datetime_field => '2012-09-01 12:00:00 +02:00' })
      expect(@object.datetime_field).to eq(Time.zone.parse('2012-09-01 12:00:00 +02:00'))
    end
  end
end

