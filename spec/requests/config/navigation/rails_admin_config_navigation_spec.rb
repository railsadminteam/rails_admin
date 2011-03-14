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

    after(:each) do
      RailsAdmin::Config.reset Fan
    end

    it "should be visible and sane by default" do
      # Reset
      RailsAdmin::Config.reset Fan

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

    it 'should display edited model name in model name column' do
      RailsAdmin.config Fan do
        label_for_navigation "NewFan"
      end
      get rails_admin_dashboard_path
      response.should have_tag("td.modelNameRow") do |model_name_cells|
        model_name_cells.should have_tag("a[href='/admin/fans']", :content => "NewFan")
      end
    end

    it 'should use edited model name in breadcrumbs' do
      RailsAdmin.config Fan do
        label_for_navigation "NewFan"
      end
      get rails_admin_list_path(:model_name => 'fans')
      response.should have_tag(".breadcrumb li") do |model_name_cells|
        model_name_cells.should have_tag("span", :content => "NewFan")
      end
    end

    it 'should use edited model name in @page_name' do
      RailsAdmin.config Fan do
        label_for_navigation "NewFan"
      end
      get rails_admin_list_path(:model_name => 'fans')
      assigns[:page_name].should =~ /NewFan/i
    end

    it "should be editable via shortcut" do
      RailsAdmin.config Fan do
        label_for_navigation "Fan test 2"
      end
      get rails_admin_dashboard_path
      response.should have_tag("#nav") do |navigation|
        navigation.should have_tag("li a", :content => "Fan test 2")
      end
    end

    it "should be editable via navigation configuration" do
      RailsAdmin.config Fan do
        navigation do
          label "Fan test 3"
        end
      end
      get rails_admin_dashboard_path
      response.should have_tag("#nav") do |navigation|
        navigation.should have_tag("li a", :content => "Fan test 3")
      end
    end

    it "should be editable with a block via navigation configuration" do
      RailsAdmin.config Fan do
        navigation do
          label do
            "#{label} test 4"
          end
        end
      end
      get rails_admin_dashboard_path
      response.should have_tag("#nav") do |navigation|
        navigation.should have_tag("li a", :content => "Fan test 4")
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

    it "should be hideable via shortcut" do
      RailsAdmin.config Fan do
        hide_from_navigation
      end
      get rails_admin_dashboard_path
      response.should have_tag("#nav") do |navigation|
        navigation.should_not have_tag("li a", :content => "Fan")
      end
    end

    it "should be hideable via navigation configuration" do
      RailsAdmin.config Fan do
        navigation do
          hide
        end
      end
      get rails_admin_dashboard_path
      response.should have_tag("#nav") do |navigation|
        navigation.should_not have_tag("li a", :content => "Fan")
      end
    end

    it "should be hideable with a block via navigation configuration" do
      RailsAdmin.config Fan do
        navigation do
          show do
            false
          end
        end
      end
      get rails_admin_dashboard_path
      response.should have_tag("#nav") do |navigation|
        navigation.should_not have_tag("li a", :content => "Fan")
      end
    end
  end
end
