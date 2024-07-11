

require 'spec_helper'

RSpec.describe RailsAdmin::Support::Datetime do
  describe '#to_flatpickr_format' do
    {
      '%D de %M de %Y, %H:%M:%S' => 'm/d/y \d\e i \d\e Y, H:i:S',
      '%d/%-m/%Y, %H:%M:%S' => 'd/n/Y, H:i:S',
      '%d de %B de %Y' => 'd \d\e F \d\e Y',
      '%-d %B %Y' => 'j F Y',
      '%F %T' => 'Y-m-d H:i:S',
      '%Y-%m-%dT%H:%M:%S%:z' => 'Y-m-d\TH:i:S+00:00',
      '%HH%MM%SS' => 'H\Hi\MS\S',
      'a%-Ha%-Ma%-Sa%:za' => '\aH\ai\as\a+00:00\a',
      '%B %-d at %-l:%M %p' => 'F j \a\t h:i K',
    }.each do |strftime_format, flatpickr_format|
      it "convert strftime_format to flatpickr_format - example #{strftime_format}" do
        expect(RailsAdmin::Support::Datetime.to_flatpickr_format(strftime_format)).to eq flatpickr_format
      end
    end

    it 'raises an error with unsupported directive' do
      expect do
        RailsAdmin::Support::Datetime.to_flatpickr_format('%C')
      end.to raise_error(/Unsupported/)
    end
  end
end
