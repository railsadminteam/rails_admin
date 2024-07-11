

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
        sort_by(created_at: :asc)
      end
      expect(adapter.user_class).to eq User::Confirmed
      expect(adapter.version_class).to eq Trail
      expect(adapter.sort_by).to eq({created_at: :asc})
    end
  end

  describe '#listing_for_model' do
    subject { RailsAdmin::Extensions::PaperTrail::AuditingAdapter.new(nil) }
    let(:model) { RailsAdmin::AbstractModel.new(PaperTrailTest) }

    it 'uses the given sort order' do
      expect_any_instance_of(ActiveRecord::Relation).to receive(:order).with(whodunnit: :asc).and_call_original
      subject.listing_for_model model, nil, :username, false, true, nil, 20
    end

    it 'uses the default order when sort is not given' do
      expect_any_instance_of(ActiveRecord::Relation).to receive(:order).with(id: :desc).and_call_original
      subject.listing_for_model model, nil, false, false, true, nil, 20
    end
  end
end
