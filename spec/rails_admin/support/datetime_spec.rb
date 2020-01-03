# encoding: utf-8

require 'spec_helper'

RSpec.describe RailsAdmin::Support::Datetime do
  describe '#to_momentjs' do
    {
      '%D de %M de %Y, %H:%M:%S' => 'MM/DD/YY [de] mm [de] YYYY, HH:mm:ss',
      '%d/%-m/%Y, %H:%M:%S' => 'DD/M/YYYY, HH:mm:ss',
      '%d de %B de %Y' => 'DD [de] MMMM [de] YYYY',
      '%-d %B %Y' => 'D MMMM YYYY',
    }.each do |strftime_format, momentjs_format|
      it "convert strftime_format to momentjs_format - example #{strftime_format}" do
        strftime_format = RailsAdmin::Support::Datetime.new(strftime_format)
        expect(strftime_format.to_momentjs).to eq momentjs_format
      end
    end
  end

  describe '.delocalize' do
    around do |example|
      I18n.with_locale(test_locale) { example.run }
    end
    let(:format) { '%a %A %d %b %B %I:%M%p' }
    let(:english_translation) { 'Thu Thursday 02 Jan January 05:30pm' }

    context 'when en locale' do
      let(:test_locale) { :en }
      let(:input) { english_translation }

      it 'returns the original string' do
        result = RailsAdmin::Support::Datetime.delocalize(input, format)
        expect(result).to eq(input)
      end
    end

    context 'when non-en locale' do
      let(:test_locale) { :fr }
      # Note: Translation uses all lower-case day/month names
      let(:input) { 'Jeu Jeudi 02 Jan. Janvier 05:30pm' }

      it 'returns the English translated string' do
        result = RailsAdmin::Support::Datetime.delocalize(input, format)
        expect(result).to eq(english_translation)
      end
    end
  end
end
