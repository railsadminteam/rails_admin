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
        expect(RailsAdmin::Support::Datetime.to_momentjs(strftime_format)).to eq momentjs_format
      end
    end
  end
end
