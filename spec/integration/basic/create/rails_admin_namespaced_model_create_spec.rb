require 'spec_helper'

describe "RailsAdmin Namespaced Model Create" do

  subject { page }

  it "creates object with correct attributes" do
    visit new_path(:model_name => "cms~basic_page")

    fill_in "cms_basic_page[title]", :with => "Hello"
    fill_in "cms_basic_page[content]", :with => "World"
    expect {
      click_button "Save" # first(:button, "Save").click
    }.to change(Cms::BasicPage, :count).by(1)
  end
end
