require 'spec_helper'

describe RailsAdmin::Config::Fields::Types::Time do
  it_behaves_like 'a generic field type', :time_field, :time

  describe '#parse_input' do
    let(:field) do
      RailsAdmin.config(FieldTest).fields.detect do |f|
        f.name == :time_field
      end
    end

    before do
      RailsAdmin.config(FieldTest) do
        field :time_field, :time
      end
    end

    before :each do
      @object = FactoryGirl.create(:field_test)
      @time = ::Time.now.getutc
    end

    after :each do
      Time.zone = 'UTC'
    end

    it 'reads %H:%M' do
      @object.time_field = field.parse_input(time_field: @time.strftime('%H:%M'))
      expect(@object.time_field.strftime('%H:%M')).to eq(@time.strftime('%H:%M'))
    end

    it 'interprets time value as UTC when timezone is specified' do
      Time.zone = 'Eastern Time (US & Canada)' # -05:00
      @object.time_field = field.parse_input(time_field: @time.strftime('%H:%M'))
      expect(@object.time_field.utc.strftime('%H:%M')).to eq(@time.strftime('%H:%M'))
    end

    context 'with a custom strftime_format' do
      let(:field) do
        RailsAdmin.config(FieldTest).fields.detect do |f|
          f.name == :time_field
        end
      end

      before do
        RailsAdmin.config(FieldTest) do
          field :time_field, :time do
            strftime_format '%I:%M %p'
          end
        end
      end

      it 'has a customization option' do
        @object.time_field = field.parse_input(time_field: @time.strftime('%I:%M %p'))
        expect(@object.time_field.strftime('%H:%M')).to eq(@time.strftime('%H:%M'))
      end
    end
  end
end
