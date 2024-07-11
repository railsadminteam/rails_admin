

require 'spec_helper'

RSpec.describe 'ShowInApp action', type: :request do
  subject { page }

  describe 'link' do
    let!(:player) { FactoryBot.create :player }

    it 'has the data-turbo: false attribute' do
      visit index_path(model_name: 'player')
      is_expected.to have_selector(%(li[title="Show in app"] a[data-turbo="false"]))
      click_link 'Show'
      is_expected.to have_selector(%(a[data-turbo="false"]), text: 'Show in app')
    end
  end
end
