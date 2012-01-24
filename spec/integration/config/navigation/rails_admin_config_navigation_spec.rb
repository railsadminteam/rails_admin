require 'spec_helper'

describe "RailsAdmin Config DSL Navigation Section" do

  subject { page }
  
  describe ".excluded_models" do
    
    excluded_models = [Division, Draft, Fan]

    before(:each) do
      RailsAdmin::Config.excluded_models = excluded_models
    end

    it "should be hidden from navigation" do
      # Make query in team's edit view to make sure loading
      # the related division model config will not mess the navigation
      visit new_path(:model_name => "team")
      within("#nav") do
        excluded_models.each do |model|
          should have_no_selector("li a", :text => model.to_s)
        end
      end
    end

    it "should raise NotFound for the list view" do
      visit index_path(:model_name => "fan")
      page.driver.status_code.should eql(404)
      find('.alert-message.error').should have_content("Model 'Fan' could not be found")
    end

    it "should raise NotFound for the create view" do
      visit new_path(:model_name => "fan")
      page.driver.status_code.should eql(404)
      find('.alert-message.error').should have_content("Model 'Fan' could not be found")
    end

    it "should be hidden from other models relations in the edit view" do
      visit new_path(:model_name => "team")
      should_not have_selector("#team_division")
      should_not have_selector("input#team_fans")
    end

    it "should raise NoMethodError when an unknown method is called" do
      begin
        RailsAdmin::Config.model Team do
          method_that_doesnt_exist
          fail "calling an unknown method should have failed"
        end
      rescue NoMethodError
        # this is what we want to happen
      end
    end
  end

  describe "order of items" do

    it "should be alphabetical by default" do
      visit dashboard_path
      ["Balls", "Bars", "Basic pages", "Comments", "Divisions", "Drafts", "Fans", "Hardballs", "Leagues", "Nested field tests", "Players", "Teams", "Unscoped pages", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 1}]").should have_content(content)
      end
    end

    it "should be ordered by weight and alphabetical order" do
      RailsAdmin.config do |config|
        config.model Team do
          weight -1
        end
      end
      visit dashboard_path
      ["Teams", "Balls", "Bars", "Basic pages", "Comments", "Divisions", "Drafts", "Fans", "Hardballs", "Leagues", "Nested field tests", "Players", "Unscoped pages", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 1}]").should have_content(content)
      end
    end

    it "should nest menu items with parent" do
      RailsAdmin.config do |config|
        config.model Comment do
          parent Cms::BasicPage
        end
      end
      visit dashboard_path
      ["Balls", "Bars", "Basic pages", "Divisions", "Drafts", "Fans", "Hardballs", "Leagues", "Nested field tests", "Players", "Teams", "Unscoped pages", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 1}]").should have_content(content)
      end
      ["Basic pages", "Comments"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[contains(@class, 'more')]/ul/li[#{i + 1}]").should have_content(content)
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
      ["Balls", "Bars", "CMS related", "Divisions", "Drafts", "Fans", "Hardballs", "Leagues", "Nested field tests", "Players", "Teams", "Unscoped pages", "Users"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 1}]").should have_content(content)
      end
      ["Basic pages", "Comments"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[contains(@class, 'more')]/ul/li[#{i + 1}]").should have_content(content)
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
      ["Balls", "Bars", "Divisions", "Drafts", "Fans", "Hardballs", "Leagues", "Nested field tests", "Players", "Teams", "Unscoped pages", "Users", "CMS related"].each_with_index do |content, i|
        find(:xpath, "//ul[@id='nav']/li[#{i + 1}]").should have_content(content)
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
