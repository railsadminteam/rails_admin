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

    it "reads %B %d, %Y by default" do
      @object.date_field = @field.parse_input({ :date_field => @time.strftime("%B %d, %Y") })
      expect(@object.date_field).to eq(::Date.parse(@time.to_s))
    end

    it "covers a timezone lag even if in UTC+n:00 timezone." do
      Time.zone = 'Tokyo' # +09:00

      @object.date_field = @field.parse_input({ :date_field => @time.strftime("%B %d, %Y") })
      expect(@object.date_field).to eq(::Date.parse(@time.to_s))
    end

    it "has a simple customization option" do
      RailsAdmin.config FieldTest do
        edit do
          field :date_field do
            date_format :default
          end
        end
      end

      @object.date_field = @field.parse_input({ :date_field => @time.strftime("%Y-%m-%d") })
      expect(@object.date_field).to eq(::Date.parse(@time.to_s))
    end

    it "has a customization option" do
      RailsAdmin.config FieldTest do
        edit do
          field :date_field do
            strftime_format "%Y/%m/%d"
          end
        end
      end

      @object.date_field = @field.parse_input({ :date_field => @time.strftime("%Y/%m/%d") })
      expect(@object.date_field).to eq(::Date.parse(@time.to_s))
    end
  end
  describe 'default value' do
    before :each do
      RailsAdmin.config FieldTest do
        field :date_field do
          default_value Date.current
        end
      end
      @object = FactoryGirl.create(:field_test)
      @time = ::Time.now.getutc
      @field = RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :date_field }
      @field.bindings = {:object => @object}
    end
    it "should contain the default value" do
      expect(@field.default_value).to eq(Date.current)
    end
    it "should propagate to the field formatted_date_value when the object is a new record" do
      object = FactoryGirl.build(:field_test)
      @field.bindings = {:object => object}
      expect(@field.formatted_date_value).to eq( Date.current.strftime("%B %d, %Y") )
    end
  end
end
