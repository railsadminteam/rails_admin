require 'spec_helper'

describe "RailsAdmin Basic Bulk Destroy" do
  subject { page }

  describe "successful bulk delete of records", :active_record => true do
    before do
      RailsAdmin::History.destroy_all
      RailsAdmin.config { |c| c.audit_with :history }
      @players = 3.times.map { FactoryGirl.create(:player) }
      @delete_ids = @players[0..1].map(&:id)
      page.driver.post(bulk_action_path(:bulk_action => 'bulk_delete', :model_name => "player", :bulk_ids => @delete_ids))

      click_button "Yes, I'm sure"
    end

    it "does not contain deleted records" do
      expect(RailsAdmin::AbstractModel.new("Player").count).to eq(1)
      expect(RailsAdmin::History.count).to eq(@delete_ids.count)
      RailsAdmin::History.all.each do |history|
        expect(history.table).to eq("Player")
      end
      RailsAdmin::History.all.each do |history|
        expect(@delete_ids).to include(history.item)
      end
      expect(page).to have_selector(".alert-success", :text => "2 Players successfully deleted")
    end
  end

  describe "cancelled bulk_deletion" do
    before do
      @players = 3.times.map { FactoryGirl.create(:player) }
      @delete_ids = @players[0..1].map(&:id)
      page.driver.post(bulk_action_path(:bulk_action => 'bulk_delete', :model_name => "player", :bulk_ids => @delete_ids))
      click_button "Cancel"
    end

    it "does not delete records" do
      expect(RailsAdmin::AbstractModel.new("Player").count).to eq(3)
    end
  end
end
