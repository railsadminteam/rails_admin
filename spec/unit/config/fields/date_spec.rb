require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Date do
  describe "#parse_input" do
    before :each do
      @object = FactoryGirl.create(:field_test)
      @time = ::Time.now.getutc
      @field = RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :date_field }
    end

    after :each do
      Time.zone = 'UTC'
    end

    it "should read %B %d, %Y by default" do
      @object.date_field = @field.parse_input({ :date_field => @time.strftime("%B %d, %Y") })
      @object.date_field.should eql(::Date.parse(@time.to_s))
    end

    it "should cover a timezone lag even if in UTC+n:00 timezone." do
      Time.zone = 'Tokyo' # +09:00

      @object.date_field = @field.parse_input({ :date_field => @time.strftime("%B %d, %Y") })
      @object.date_field.should eql(::Date.parse(@time.to_s))
    end

    it "should have a simple customization option" do
      RailsAdmin.config FieldTest do
        edit do
          field :date_field do
            date_format :default
          end
        end
      end

      @object.date_field = @field.parse_input({ :date_field => @time.strftime("%Y-%m-%d") })
      @object.date_field.should eql(::Date.parse(@time.to_s))
    end

    it "should have a customization option" do
      RailsAdmin.config FieldTest do
        edit do
          field :date_field do
            strftime_format "%Y/%m/%d"
          end
        end
      end

      @object.date_field = @field.parse_input({ :date_field => @time.strftime("%Y/%m/%d") })
      @object.date_field.should eql(::Date.parse(@time.to_s))
    end
  end
end