require 'spec_helper'

describe "RailsAdmin Basic Bulk Destroy" do
  describe "successful bulk delete of records" do
    before(:each) do
      RailsAdmin::History.destroy_all

      to_delete = []
      to_delete << RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      to_delete << RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 23, :name => "Michael Jackson", :position => "Shooting guard")

      @delete_ids = to_delete.map(&:id)
      get rails_admin_bulk_delete_path(:model_name => "player", :bulk_ids => @delete_ids)

      click_button "Yes, I'm sure"
    end

    it "should be successful" do
      response.should be_successful
    end

    it "should not contain deleted records" do
      RailsAdmin::AbstractModel.new("Player").count.should == 1
    end

    it "history count should be equal to number of deleted records" do
      RailsAdmin::History.count.should == @delete_ids.count
    end

    it "history items should be for proper table" do
      RailsAdmin::History.all.each do |history|
        history.table.should == "Player"
      end
    end

    it "history items should be for proper items" do
      RailsAdmin::History.all.each do |history|
        @delete_ids.should include(history.item)
      end
    end
  end

  describe "cancelled bulk_deletion" do
    before(:each) do
      RailsAdmin::History.destroy_all

      to_delete = []
      to_delete << RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      to_delete << RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 23, :name => "Michael Jackson", :position => "Shooting guard")

      @delete_ids = to_delete.map(&:id)
      get rails_admin_bulk_delete_path(:model_name => "player", :bulk_ids => @delete_ids)

      click_button "Cancel"
    end

    it "should be successful" do
      response.should be_successful
    end

    it "should not delete records" do
      RailsAdmin::AbstractModel.new("Player").count.should == 3
    end
  end
end
