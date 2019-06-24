require 'spec_helper'

describe 'BulkExport action', type: :request do
  subject { page }

  before do
    @players = FactoryBot.create_list(:player, 2)
  end

  it 'shows form for export' do
    visit index_path(model_name: 'player')
    click_link 'Export found Players'
    is_expected.to have_content('Select fields to export')
  end
end
