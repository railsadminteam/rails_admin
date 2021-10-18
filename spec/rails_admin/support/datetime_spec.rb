# encoding: utf-8

require 'spec_helper'

RSpec.describe RailsAdmin::Support::Datetime do
  describe '#to_momentjs' do
    {
      '%D de %M de %Y, %H:%M:%S' => 'MM/DD/YY [de] mm [de] YYYY, HH:mm:ss',
      '%d/%-m/%Y, %H:%M:%S' => 'DD/M/YYYY, HH:mm:ss',
      '%d de %B de %Y' => 'DD [de] MMMM [de] YYYY',
      '%-d %B %Y' => 'D MMMM YYYY',
      '%F %T' => 'YYYY-MM-DD HH:mm:ss',
      '%Y-%m-%dT%H:%M:%S%:z' => 'YYYY-MM-DD[T]HH:mm:ssZ',
      '%HH%MM%SS' => 'HH[H]mm[M]ss[S]',
      'a%-Ha%-Ma%-Sa%3Na%:za' => '[a]H[a]m[a]s[a]SSS[a]Z[a]',
    }.each do |strftime_format, momentjs_format|
      it "convert strftime_format to momentjs_format - example #{strftime_format}" do
        expect(RailsAdmin::Support::Datetime.to_momentjs(strftime_format)).to eq momentjs_format
      end
    end

    it 'raises an error with unsupported directive' do
      expect do
        RailsAdmin::Support::Datetime.to_momentjs('%C')
      end.to raise_error(/Unsupported/)
    end
  end
end
