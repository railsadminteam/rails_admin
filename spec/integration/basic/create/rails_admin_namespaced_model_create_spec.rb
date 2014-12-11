require 'spec_helper'

describe 'RailsAdmin Namespaced Model Create', type: :request do
  subject { page }

  it 'creates object with correct attributes' do
    visit new_path(model_name: 'cms~basic_page')

    fill_in 'cms_basic_page[title]', with: 'Hello'
    fill_in 'cms_basic_page[content]', with: 'World'
    expect do
      click_button 'Save' # first(:button, "Save").click
    end.to change(Cms::BasicPage, :count).by(1)
  end
end
