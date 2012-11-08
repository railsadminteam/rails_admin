require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Timestamp do
  describe "#parse_input", :active_record => true do
    before :each do
      @object = FactoryGirl.create(:field_test)
      @time = ::Time.now.getutc
      @field = RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :timestamp_field }
    end

    after :each do
      Time.zone = 'UTC'
    end

    it "reads %B %d, %Y %H:%M" do
      @object.timestamp_field = @field.parse_input({ :timestamp_field => @time.strftime("%B %d, %Y %H:%M") })
      expect(@object.timestamp_field.strftime("%Y-%m-%d %H:%M")).to eq(@time.strftime("%Y-%m-%d %H:%M"))
    end
  end
end
