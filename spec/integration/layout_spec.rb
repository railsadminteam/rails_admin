# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Layout', type: :request do
  it 'renders a well-formed viewport meta tag' do
    visit index_path(model_name: 'player')
    expect(page).to have_css('meta[name="viewport"][content="width=device-width, initial-scale=1"]', visible: false)
  end
end
