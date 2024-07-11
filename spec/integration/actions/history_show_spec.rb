

require 'spec_helper'

RSpec.describe 'HistoryShow action', type: :request, active_record: true do
  let(:user) { FactoryBot.create :user }
  let(:paper_trail_test) { FactoryBot.create :paper_trail_test }
  before(:each) do
    RailsAdmin.config do |config|
      config.audit_with :paper_trail, 'User', 'PaperTrail::Version'
    end

    PaperTrail::Version.delete_all
    with_versioning do
      PaperTrail.request.whodunnit = user.id
      30.times do |i|
        paper_trail_test.update!(name: "updated name #{i}")
      end
    end
  end

  it 'shows the history' do
    visit history_show_path(model_name: 'paper_trail_test', id: paper_trail_test.id)
    expect(all('table#history tbody tr').count).to eq(20)
  end

  it 'supports pagination' do
    visit history_show_path(model_name: 'paper_trail_test', id: paper_trail_test.id, page: 2)
    expect(all('table#history tbody tr').count).to eq(11)
  end

  context "when Kaminari's custom param_name is set" do
    before { Kaminari.config.param_name = :pagina }
    after { Kaminari.config.param_name = :page }

    it 'picks the page value from params' do
      visit history_show_path(model_name: 'paper_trail_test', id: paper_trail_test.id, pagina: 2)
      expect(all('table#history tbody tr').count).to eq(11)
    end
  end
end
