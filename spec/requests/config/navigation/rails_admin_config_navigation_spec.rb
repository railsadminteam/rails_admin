require 'spec_helper'

describe "RailsAdmin Config DSL Navigation Section" do

  subject { page }

  describe "order of items" do

    it "should be alphabetical by default" do
      visit rails_admin_dashboard_path
      ["Cms/Basic Pages", "Comments", "Divisions", "Drafts", "Fans", "Leagues", "Players", "Teams", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
    end

    it "should be ordered by weight and alphabetical order" do
      RailsAdmin.config do |config|
        config.model Team do
          weight -1
        end
      end
      visit rails_admin_dashboard_path
      ["Teams", "Cms/Basic Pages", "Comments", "Divisions", "Drafts", "Fans", "Leagues", "Players", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
    end

    it "should nest menu items with parent" do
      RailsAdmin.config do |config|
        config.model Comment do
          parent Cms::BasicPage
        end
      end
      visit rails_admin_dashboard_path
      ["Cms/Basic Pages", "Divisions", "Drafts", "Fans", "Leagues", "Players", "Teams", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
      ["Cms/Basic Pages", "Comments"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[contains(@class, 'more')]/ul/li[#{i + 1}]/a").should have_content(content)
      end
    end

    it "should override parent label with dropdown" do
      RailsAdmin.config do |config|
        config.model Comment do
          parent Cms::BasicPage
        end
        config.model Cms::BasicPage do
          dropdown "CMS related"
        end
      end
      visit rails_admin_dashboard_path
      ["CMS related", "Divisions", "Drafts", "Fans", "Leagues", "Players", "Teams", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
      ["Cms/Basic Pages", "Comments"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[contains(@class, 'more')]/ul/li[#{i + 1}]/a").should have_content(content)
      end
    end

    it "should order dropdown item according to parent weight" do
      RailsAdmin.config do |config|
        config.model Comment do
          parent Cms::BasicPage
        end
        config.model Cms::BasicPage do
          dropdown "CMS related"
          weight 1
        end
      end
      visit rails_admin_dashboard_path
      ["Divisions", "Drafts", "Fans", "Leagues", "Players", "Teams", "Users", "CMS related"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
    end
  end

  describe "label for a model" do

    it "should be visible and sane by default" do
      visit rails_admin_dashboard_path
      within("#nav") do
        should have_selector("li a", :text => "Fan")
      end
    end

    it "should be editable" do
      RailsAdmin.config Fan do
        label "Fan test 1"
      end
      visit rails_admin_dashboard_path
      within("#nav") do
        should have_selector("li a", :text => "Fan test 1")
      end
    end

    it "should be hideable" do
      RailsAdmin.config Fan do
        hide
      end
      visit rails_admin_dashboard_path
      within("#nav") do
        should have_no_selector("li a", :text => "Fan")
      end
    end
  end
end
