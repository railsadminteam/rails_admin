require 'spec_helper'

describe "RailsAdmin Config DSL Navigation Section" do

  describe "number of visible tabs" do
    after(:each) do
      RailsAdmin.config do |config|
        config.navigation.max_visible_tabs 5
      end
    end

    it "should be editable" do
      RailsAdmin.config do |config|
        config.navigation.max_visible_tabs 2
      end
      get rails_admin_dashboard_path
      response.should have_tag("#nav > li") do |elements|
        elements.should have_at_most(4).items
      end
    end
  end

  describe "label for a model" do

    it "should be visible and sane by default" do
      get rails_admin_dashboard_path
      response.should have_tag("#nav") do |navigation|
        navigation.should have_tag("li a", :content => "Fan")
      end
    end

    it "should be editable" do
      RailsAdmin.config Fan do
        label "Fan test 1"
      end
      get rails_admin_dashboard_path
      response.should have_tag("#nav") do |navigation|
        navigation.should have_tag("li a", :content => "Fan test 1")
      end
    end

    it "should be hideable" do
      RailsAdmin.config Fan do
        hide
      end
      get rails_admin_dashboard_path
      response.should have_tag("#nav") do |navigation|
        navigation.should_not have_tag("li a", :content => "Fan")
      end
    end
  end
end
