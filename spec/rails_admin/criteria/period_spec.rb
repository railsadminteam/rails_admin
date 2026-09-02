# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Criteria::Period do
  describe '#bounds' do
    it 'resolves an explicit range' do
      expect(described_class.new('between', ['', Date.new(2012, 2, 1), Date.new(2012, 3, 1)]).bounds).
        to eq [Date.new(2012, 2, 1), Date.new(2012, 3, 1)]
    end

    it 'leaves an open end of a range nil' do
      expect(described_class.new('between', ['', Date.new(2012, 2, 1), nil]).bounds).
        to eq [Date.new(2012, 2, 1), nil]
    end

    it 'resolves a single value to a point' do
      expect(described_class.new('default', [Date.new(2012, 2, 1)]).bounds).
        to eq [Date.new(2012, 2, 1), Date.new(2012, 2, 1)]
    end

    context 'with relative operators' do
      around do |example|
        Time.use_zone('Asia/Tokyo') { example.run }
      end

      it 'resolves today' do
        expect(described_class.new('today', []).bounds).to eq [Date.current, Date.current]
      end

      it 'resolves yesterday' do
        expect(described_class.new('yesterday', []).bounds).to eq [Date.current.yesterday, Date.current.yesterday]
      end

      it 'resolves this week' do
        expect(described_class.new('this_week', []).bounds).
          to eq [Date.current.beginning_of_week, Date.current.end_of_week]
      end

      it 'resolves last week' do
        last_week = Date.current - 1.week
        expect(described_class.new('last_week', []).bounds).
          to eq [last_week.beginning_of_week, last_week.end_of_week]
      end

      # Date.today reads the system clock rather than the application time zone.
      # Mixing the two made today and yesterday land on dates that were not a day
      # apart whenever the zones disagreed on the date, which they do for part of
      # every day.
      it 'never reads the date off the system clock' do
        allow(Date).to receive(:today).and_return(Date.current + 5)

        expect(described_class.new('today', []).bounds).to eq [Date.current, Date.current]
        expect(described_class.new('this_week', []).bounds).
          to eq [Date.current.beginning_of_week, Date.current.end_of_week]
      end

      it 'keeps every relative period in the same time zone' do
        today = described_class.new('today', []).bounds.first
        expect(described_class.new('yesterday', []).bounds.first).to eq today - 1
        expect(described_class.new('this_week', []).bounds.first).to eq today.beginning_of_week
        expect(described_class.new('last_week', []).bounds.first).to eq (today - 1.week).beginning_of_week
      end
    end
  end
end
