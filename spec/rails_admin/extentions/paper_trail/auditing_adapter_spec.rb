# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RailsAdmin::Extensions::PaperTrail::AuditingAdapter, active_record: true do
  let(:controller) { double(set_paper_trail_whodunnit: nil) }

  describe '#initialize' do
    it 'accepts the user and version classes as arguments' do
      adapter = described_class.new(controller, User::Confirmed, Trail)
      expect(adapter.user_class).to eq User::Confirmed
      expect(adapter.version_class).to eq Trail
    end

    it 'supports block DSL' do
      adapter = described_class.new(controller) do
        user_class User::Confirmed
        version_class Trail
      end
      expect(adapter.user_class).to eq User::Confirmed
      expect(adapter.version_class).to eq Trail
    end
  end
end
