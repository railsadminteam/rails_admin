

require 'spec_helper'

RSpec.describe RailsAdmin::Config::Fields::Types::ActiveRecordEnum, active_record: true do
  it_behaves_like 'a generic field type', :string_enum_field

  describe '#pretty_value' do
    context 'when column name is format' do
      before do
        class FormatAsEnum < FieldTest
          enum format: {Text: 'txt', Markdown: 'md'}
        end
      end
      let(:field) do
        RailsAdmin.config(FormatAsEnum).fields.detect do |f|
          f.name == :format
        end.with(object: FormatAsEnum.new(format: 'md'))
      end

      it 'does not break' do
        expect(field.pretty_value).to eq 'Markdown'
      end
    end
  end
end
