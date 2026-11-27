# frozen_string_literal: true

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

  it 'keeps the sort and drops the page on search' do
    visit history_index_path(model_name: 'paper_trail_test', sort: 'item', sort_reverse: 'true', page: 2)
    fill_in 'query', with: 'update'
    click_button 'Refresh'
    expect(page).to have_current_path(/query=update/)
    expect(Rack::Utils.parse_query(URI.parse(current_url).query)).to eq('query' => 'update', 'sort' => 'item', 'sort_reverse' => 'true')
  end

  it 'drops the page from the sort links' do
    visit history_index_path(model_name: 'paper_trail_test', page: 2)
    queries = all('th.header', minimum: 1).map { |th| Rack::Utils.parse_query(URI.parse(th['data-href']).query) }
    expect(queries).to all(include('sort'))
    expect(queries.flat_map(&:keys)).not_to include('page')
  end

  context "when Kaminari's custom param_name is set" do
    before { Kaminari.config.param_name = :pagina }
    after { Kaminari.config.param_name = :page }

    it 'picks the page value from params' do
      visit history_index_path(model_name: 'paper_trail_test', pagina: 2)
      is_expected.to have_css(%([href="/admin/paper_trail_test/#{paper_trail_test.id}"]), count: 11)
    end

    it 'drops the page on search' do
      visit history_index_path(model_name: 'paper_trail_test', sort: 'item', pagina: 2)
      fill_in 'query', with: 'update'
      click_button 'Refresh'
      expect(page).to have_current_path(/query=update/)
      expect(Rack::Utils.parse_query(URI.parse(current_url).query)).to eq('query' => 'update', 'sort' => 'item')
    end

    it 'drops the page from the sort links' do
      visit history_index_path(model_name: 'paper_trail_test', pagina: 2)
      queries = all('th.header', minimum: 1).map { |th| Rack::Utils.parse_query(URI.parse(th['data-href']).query) }
      expect(queries).to all(include('sort'))
      expect(queries.flat_map(&:keys)).not_to include('pagina')
    end
  end
end
