require 'spec_helper'

describe "RailsAdmin Namespaced Model Create" do

  before(:each) do
    get rails_admin_new_path(:model_name => "cms~basic_page")

    fill_in "cms_basic_page[title]", :with => "Hello"
    fill_in "cms_basic_page[content]", :with => "World"
  end

  it 'should be successful' do
    click_button "Save"
    response.should be_successful
  end

  it 'should create object with correct attributes' do
    expect {
      click_button "Save"
    }.to change(Cms::BasicPage, :count).by(1)
  end

end
