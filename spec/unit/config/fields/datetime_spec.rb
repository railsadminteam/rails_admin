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

    it "should be able to read %B %d, %Y %H:%M" do
      @object = FactoryGirl.create(:field_test)
      @object.datetime_field = @field.parse_input({ :datetime_field => @time.strftime("%B %d, %Y %H:%M") })
      @object.datetime_field.strftime("%Y-%m-%d %H:%M").should eql(@time.strftime("%Y-%m-%d %H:%M"))     
    end

    it "should be able to read %a, %d %b %Y %H:%M:%S" do
      RailsAdmin.config FieldTest do
        edit do
          field :datetime_field do
            date_format :default
          end
        end
      end
      @object = FactoryGirl.create(:field_test)
      @object.datetime_field = @field.parse_input({ :datetime_field => @time.strftime("%a, %d %b %Y %H:%M:%S") })
      @object.datetime_field.to_s(:rfc822).should eql(@time.to_s(:rfc822))     
    end

    it "should have a customization option" do
      RailsAdmin.config FieldTest do
        list do
          field :datetime_field do
            strftime_format "%Y-%m-%d %H:%M:%S"
          end
        end
      end
      @object = FactoryGirl.create(:field_test)
      @object.datetime_field = @field.parse_input({ :datetime_field => @time.strftime("%Y-%m-%d %H:%M:%S") })
      @object.datetime_field.to_s(:rfc822).should eql(@time.to_s(:rfc822))     
    end

    it "should do round-trip saving properly with non-UTC timezones" do
      Time.zone = 'Vienna'
      @object = FactoryGirl.create(:field_test)
      @object.datetime_field = @field.parse_input({ :datetime_field => '2012-09-01 12:00:00 +02:00' })
      @object.datetime_field.should == Time.zone.parse('2012-09-01 12:00:00 +02:00')
    end
  end
end

