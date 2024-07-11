

require 'spec_helper'

RSpec.describe 'HistoryIndex action', type: :request, active_record: true do
  subject { page }

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
    visit history_index_path(model_name: 'paper_trail_test')
    is_expected.to have_css(%([href="/admin/paper_trail_test/#{paper_trail_test.id}"]), count: 20)
  end

  it 'supports pagination' do
    visit history_index_path(model_name: 'paper_trail_test', page: 2)
    is_expected.to have_css(%([href="/admin/paper_trail_test/#{paper_trail_test.id}"]), count: 11)
  end

  it 'supports sorting', js: true do
    visit history_index_path(model_name: 'paper_trail_test')
    find('th.header', text: 'Item').click
    is_expected.to have_css('th.item.headerSortDown')
  end

  context "when Kaminari's custom param_name is set" do
    before { Kaminari.config.param_name = :pagina }
    after { Kaminari.config.param_name = :page }

    it 'picks the page value from params' do
      visit history_index_path(model_name: 'paper_trail_test', pagina: 2)
      is_expected.to have_css(%([href="/admin/paper_trail_test/#{paper_trail_test.id}"]), count: 11)
    end
  end
end
