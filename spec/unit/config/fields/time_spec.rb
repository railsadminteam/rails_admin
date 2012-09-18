require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Time do
  describe "#parse_input" do
    before :each do
      @object = FactoryGirl.create(:field_test)
      @time = ::Time.now.getutc
      @field = RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :time_field }
    end

    after :each do
      Time.zone = 'UTC'
    end

    it "should read %H:%M" do
      @object.time_field = @field.parse_input({ :time_field => @time.strftime("%H:%M") })
      @object.time_field.strftime("%H:%M").should eql(@time.strftime("%H:%M"))
    end

    it "should interpret time value as UTC when timezone is specified" do
      Time.zone = 'Eastern Time (US & Canada)' # -05:00
      @object.time_field = @field.parse_input({ :time_field => @time.strftime("%H:%M") })
      @object.time_field.strftime("%H:%M").should eql(@time.strftime("%H:%M"))
    end

    it "should have a customization option" do
      RailsAdmin.config FieldTest do
        edit do
          field :time_field do
            strftime_format "%I:%M %p"
          end
        end
      end
      @object.time_field = @field.parse_input({ :time_field => @time.strftime("%I:%M %p") })
      @object.time_field.strftime("%H:%M").should eql(@time.strftime("%H:%M"))
    end
  end
end

