# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Timestamp, active_record: true do
  it_behaves_like 'a generic field type', :timestamp_field, :timestamp

  describe '#parse_input' do
    before :each do
      @object = FactoryBot.create(:field_test)
      @time = ::Time.now.getutc
      @field = RailsAdmin.config(FieldTest).fields.detect { |f| f.name == :timestamp_field }
    end

    after :each do
      Time.zone = 'UTC'
    end

    it 'reads %B %d, %Y %H:%M' do
      @object.timestamp_field = @field.parse_input(timestamp_field: @time.strftime('%B %d, %Y %H:%M'))
      expect(@object.timestamp_field.strftime('%Y-%m-%d %H:%M')).to eq(@time.strftime('%Y-%m-%d %H:%M'))
    end
  end

  describe 'aliasing' do
    before :each do
      RailsAdmin.config do |config|
        config.model FieldTest do
          field :timestamp_field, :timestamptz
        end
      end
    end

    it 'allows use of :timestamptz fieldtype' do
      field = RailsAdmin.config(FieldTest).fields.detect { |f| f.name == :timestamp_field }
      expect(field.class).to eq RailsAdmin::Config::Fields::Types::Timestamp
    end
  end
end
