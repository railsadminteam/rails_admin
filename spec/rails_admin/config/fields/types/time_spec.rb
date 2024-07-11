

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::Time, active_record: true do
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
      @object = FactoryBot.create(:field_test)
      @time = ::Time.new(2000, 1, 1, 3, 45)
    end

    after :each do
      Time.zone = 'UTC'
    end

    it 'reads %H:%M' do
      @object.time_field = field.parse_input(time_field: @time.strftime('%H:%M'))
      expect(@object.time_field.strftime('%H:%M')).to eq(@time.strftime('%H:%M'))
    end

    it 'interprets time value as local time when timezone is specified' do
      Time.zone = 'Eastern Time (US & Canada)' # -05:00
      @object.time_field = field.parse_input(time_field: '2000-01-01T03:45:00')
      expect(@object.time_field.strftime('%H:%M')).to eq('03:45')
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
