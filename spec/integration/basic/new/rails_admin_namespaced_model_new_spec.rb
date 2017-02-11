require 'spec_helper'

describe 'RailsAdmin Namespaced Model New', type: :request do
  subject { page }

  describe 'AbstractModel#to_param' do
    it 'turns namespaces into prefixes with ~' do
      expect(RailsAdmin::AbstractModel.new('Cms::BasicPage').to_param).to eq('cms~basic_page')
    end
  end

  describe 'ApplicationController#to_model_name' do
    it 'turns cms~basic_page into Cms::BasicPage' do
      expect(RailsAdmin::ApplicationController.new.to_model_name('cms~basic_page')).to eq('Cms::BasicPage')
    end
  end

  describe 'GET /admin/cms_basic_page/new' do
    it 'has correct input field names' do
      visit new_path(model_name: 'cms~basic_page')

      is_expected.to have_selector('label[for=cms_basic_page_title]')
      is_expected.to have_selector("input#cms_basic_page_title[name='cms_basic_page[title]']")
      is_expected.to have_selector('label[for=cms_basic_page_content]')
      is_expected.to have_selector("textarea#cms_basic_page_content[name='cms_basic_page[content]']")
    end

    it 'has default values' do
      content = '4123lkj1sdlfjasdfjsdkfjsdfk'

      visit new_path(model_name: 'cms~basic_page', cms_basic_page: {content: content})

      within('#cms_basic_page_content_field') do
        is_expected.to have_content(content)
      end
    end
  end
end
