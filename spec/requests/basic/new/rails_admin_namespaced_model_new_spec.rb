require 'spec_helper'

describe "RailsAdmin Namespaced Model New" do

  describe "AbstractModel#to_param" do
    it 'turns namespaces into prefixes with ~' do
      RailsAdmin::AbstractModel.new("Cms::BasicPage").to_param.should == 'cms~basic_pages'
    end
  end

  describe "ApplicationController#to_model_name" do
    it 'turns cms~basic_pages into Cms::BasicPage' do
      RailsAdmin::ApplicationController.new.to_model_name('cms~basic_pages').should == 'Cms::BasicPage'
    end
  end

  describe "GET /admin/cms_basic_page/new" do
    before(:each) do
      get rails_admin_new_path(:model_name => "cms~basic_page")
    end

    it "should respond successfully", :only =>true do
      response.should be_successful
    end

    it 'should have correct input field names' do
      response.should have_selector("label[for=cms_basic_page_title]")
      response.should have_selector("input#cms_basic_page_title[name='cms_basic_page[title]']")
      response.should have_selector("label[for=cms_basic_page_content]")
      response.should have_selector("textarea#cms_basic_page_content[name='cms_basic_page[content]']")
    end
  end
end
