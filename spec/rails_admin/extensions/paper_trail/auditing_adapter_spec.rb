require 'spec_helper'

describe RailsAdmin::Extensions::PaperTrail::AuditingAdapter, :active_record => true do
  subject { RailsAdmin::Extensions::PaperTrail::AuditingAdapter.new(ApplicationController.new) }
  before do
    RailsAdmin.config do |config|
      config.audit_with :paper_trail
    end
    class PaperTrail::Version < ActiveRecord::Base
      self.table_name = :versions
    end
  end

  describe '#latest' do
    before do
      @model = RailsAdmin::AbstractModel.new("Player")
      class Player < ActiveRecord::Base
        has_paper_trail
      end
      with_versioning do
        player = Player.create(:team_id => -1, :number => -1, :name => "Player 1")
        99.times { |i| player.update_attributes(:number => i) }
      end
    end
    it 'gets 100 latest items in descendant order' do
      latest = subject.latest
      expect(latest.first.message).to eq('update []')
      expect(latest.last.message).to eq('create []')
    end
  end
end
