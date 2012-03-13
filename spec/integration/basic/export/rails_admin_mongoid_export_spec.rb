require 'spec_helper'

describe "RailsAdmin Mongoid Export" do

  subject { page }

  before(:each) do
    @authors = 3.times.map { FactoryGirl.create :author }
  end

  describe "POST /admin/author/export (prompt)" do

    it "should allow to export to CSV" do
      visit export_path(:model_name => 'author')
      should have_content 'Select fields to export'
      Rails.configuration.should_not_receive(:database_configuration)
      click_button 'Export to csv'
      should have_content "Name"
      should have_content @authors[0].name
      should have_content @authors[2].name
    end
  end
end
