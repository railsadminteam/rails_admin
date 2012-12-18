require 'spec_helper'

describe "RailsAdmin Basic Bulk Destroy" do
  subject { page }

  describe "successful bulk delete of records", :active_record => true do
    before do
      RailsAdmin::History.destroy_all
      RailsAdmin.config { |c| c.audit_with :history }
      @players = 3.times.map { FactoryGirl.create(:player) }
      @delete_ids = @players[0..1].map(&:id)

      # NOTE: This uses an internal, unsupported capybara API which could break at any moment. We
      # should refactor this test so that it either A) uses capybara's supported API (only GET
      # requests via visit) or B) just uses Rack::Test (and doesn't use capybara for browser
      # interaction like click_button).
      page.driver.browser.reset_host!
      page.driver.browser.process :post, bulk_action_path(:bulk_action => 'bulk_delete', :model_name => "player", :bulk_ids => @delete_ids, '_method' => 'post')
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

      # NOTE: This uses an internal, unsupported capybara API which could break at any moment. We
      # should refactor this test so that it either A) uses capybara's supported API (only GET
      # requests via visit) or B) just uses Rack::Test (and doesn't use capybara for browser
      # interaction like click_button).
      page.driver.browser.reset_host!
      page.driver.browser.process :post, bulk_action_path(:bulk_action => 'bulk_delete', :model_name => "player", :bulk_ids => @delete_ids, '_method' => 'post')
      click_button "Cancel"
    end

    it "does not delete records" do
      expect(RailsAdmin::AbstractModel.new("Player").count).to eq(3)
    end
  end
end
