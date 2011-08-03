require 'spec_helper'

describe "RailsAdmin Config DSL Navigation Section" do

  subject { page }

  describe "order of items" do

    it "should be alphabetical by default" do
      visit dashboard_path
      ["Balls", "Basic pages", "Comments", "Divisions", "Drafts", "Fans", "Leagues", "Players", "Teams", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
    end

    it "should be ordered by weight and alphabetical order" do
      RailsAdmin.config do |config|
        config.model Team do
          weight -1
        end
      end
      visit dashboard_path
      ["Teams", "Balls", "Basic pages", "Comments", "Divisions", "Drafts", "Fans", "Leagues", "Players", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
    end

    it "should nest menu items with parent" do
      RailsAdmin.config do |config|
        config.model Comment do
          parent Cms::BasicPage
        end
      end
      visit dashboard_path
      ["Balls", "Basic pages", "Divisions", "Drafts", "Fans", "Leagues", "Players", "Teams", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
      ["Basic pages", "Comments"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[contains(@class, 'more')]/ul/li[#{i + 1}]/a").should have_content(content)
      end
    end

    it "should override parent label with navigation_label" do
      RailsAdmin.config do |config|
        config.model Comment do
          parent Cms::BasicPage
        end
        config.model Cms::BasicPage do
          navigation_label "CMS related"
        end
      end
      visit dashboard_path
      ["Balls", "CMS related", "Divisions", "Drafts", "Fans", "Leagues", "Players", "Teams", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
      ["Basic pages", "Comments"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[contains(@class, 'more')]/ul/li[#{i + 1}]/a").should have_content(content)
      end
    end

    it "should order navigation_label item according to parent weight" do
      RailsAdmin.config do |config|
        config.model Comment do
          parent Cms::BasicPage
        end
        config.model Cms::BasicPage do
          navigation_label "CMS related"
          weight 1
        end
      end
      visit dashboard_path
      ["Balls", "Divisions", "Drafts", "Fans", "Leagues", "Players", "Teams", "Users", "CMS related"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 2}]/a").should have_content(content)
      end
    end
  end

  describe "label for a model" do

    it "should be visible and sane by default" do
      visit dashboard_path
      within("#nav") do
        should have_selector("li a", :text => "Fan")
      end
    end

    it "should be editable" do
      RailsAdmin.config Fan do
        label_plural "Fan tests"
      end
      visit dashboard_path
      within("#nav") do
        should have_selector("li a", :text => "Fan tests")
      end
    end

    it "should be hideable" do
      RailsAdmin.config Fan do
        hide
      end
      visit dashboard_path
      within("#nav") do
        should have_no_selector("li a", :text => "Fan")
      end
    end
  end
end
