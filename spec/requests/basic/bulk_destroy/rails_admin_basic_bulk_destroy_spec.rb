require 'spec_helper'

describe "RailsAdmin Basic Bulk Destroy" do
  include ActionView::Helpers::TextHelper

  subject { page }

  describe "successful bulk delete of records" do
    before(:each) do
      RailsAdmin::History.destroy_all
      @players = 3.times.map { FactoryGirl.create(:player) }
      @delete_ids = @players[0..1].map(&:id)
      page.driver.post(rails_admin_bulk_action_path(:bulk_action => 'delete', :model_name => "player", :bulk_ids => @delete_ids))

      click_button "Yes, I'm sure"
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

    it "displays a flash notice stating the number of records destroyed" do
      name = pluralize(@delete_ids.count, @players.first.class.to_s)
      page.should have_selector('div.flash div.notice p', :text => I18n.t("admin.flash.successful", :name => name, :action => I18n.t("admin.actions.deleted")))
    end
  end

  describe "cancelled bulk_deletion" do
    before(:each) do
      RailsAdmin::History.destroy_all
      @players = 3.times.map { FactoryGirl.create(:player) }
      @delete_ids = @players[0..1].map(&:id)
      page.driver.post(rails_admin_bulk_action_path(:bulk_action => 'delete', :model_name => "player", :bulk_ids => @delete_ids))
      click_button "Cancel"
    end

    it "should not delete records" do
      RailsAdmin::AbstractModel.new("Player").count.should == 3
    end
  end
end
