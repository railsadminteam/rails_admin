require 'spec_helper'

describe "RailsAdmin Basic Bulk Action" do

  subject { page }

  before(:each) do
    @players = 2.times.map { FactoryGirl.create :player }
  end

  describe "bulk_delete" do
    it 'should show names of to-be-deleted players' do
      page.driver.post(bulk_action_path(:bulk_action => 'bulk_delete', :model_name => "player", :bulk_ids => @players.map(&:id)))
      @players.each { |player| should have_content(player.name) }
    end
  end

  describe "bulk_export" do
    it 'should show form for export' do
      visit index_path(:model_name => "player")
      click_link "Export found Players"
      @players.each { |player| should have_content("Select fields to export") }
    end
  end
end
