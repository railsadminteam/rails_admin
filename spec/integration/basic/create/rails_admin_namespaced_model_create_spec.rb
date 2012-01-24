require 'spec_helper'

describe "RailsAdmin Namespaced Model Create" do

  subject { page }

  before(:each) do
    visit new_path(:model_name => "cms~basic_page")

    fill_in "cms_basic_page[title]", :with => "Hello"
    fill_in "cms_basic_page[content]", :with => "World"
  end

  it 'should be successful' do
    click_button "Save"
  end

  it 'should create object with correct attributes' do
    expect {
      click_button "Save"
    }.to change(Cms::BasicPage, :count).by(1)
  end
end


describe "RailsAdmin Mounted Engine Model Create" do

  subject { page }

  before(:each) do
    visit new_path(:model_name => "foo~bar")
    fill_in "foo_bar[title]", :with => "Hello"
    click_button "Save"
  end

  it 'should be successful' do
    Foo::Bar.first.title.should == 'Hello'
  end
end
