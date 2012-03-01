require 'spec_helper'
require 'rails_admin/extensions/history/history'

describe "RailsAdmin Basic Bulk Destroy" do
  subject { page }

  describe "successful bulk delete of records" do
    before do
      RailsAdmin::History.destroy_all
      RailsAdmin.config { |c| c.audit_with :history }
      @players = 3.times.map { FactoryGirl.create(:player) }
      @delete_ids = @players[0..1].map(&:id)
      page.driver.post(bulk_action_path(:bulk_action => 'bulk_delete', :model_name => "player", :bulk_ids => @delete_ids))

      click_button "Yes, I'm sure"
    end

    it "should not contain deleted records" do
      RailsAdmin::AbstractModel.new("Player").count.should == 1
      RailsAdmin::History.count.should == @delete_ids.count
      RailsAdmin::History.all.each do |history|
        history.table.should == "Player"
      end
      RailsAdmin::History.all.each do |history|
        @delete_ids.should include(history.item)
      end
      page.should have_selector(".alert-success", :text => "2 Players successfully deleted")
    end
  end

  describe "cancelled bulk_deletion" do
    before do
      RailsAdmin::History.destroy_all
      @players = 3.times.map { FactoryGirl.create(:player) }
      @delete_ids = @players[0..1].map(&:id)
      page.driver.post(bulk_action_path(:bulk_action => 'bulk_delete', :model_name => "player", :bulk_ids => @delete_ids))
      click_button "Cancel"
    end

    it "should not delete records" do
      RailsAdmin::AbstractModel.new("Player").count.should == 3
    end
  end
end
