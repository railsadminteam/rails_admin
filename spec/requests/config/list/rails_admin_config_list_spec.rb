require 'spec_helper'

describe "RailsAdmin Config DSL List Section" do

  describe "number of items per page" do

    before(:each) do
      RailsAdmin::AbstractModel.new("League").create(:name => 'American')
      RailsAdmin::AbstractModel.new("League").create(:name => 'National')
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher", :retired => true, :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman", :retired => true, :injured => false)
    end

    it "should be configurable" do
      RailsAdmin::Config.models do
        list do
          items_per_page 1
        end
      end
      get rails_admin_list_path(:model_name => "league")
      response.should have_tag("#contentMainModules > table > .infoRow") do |elements|
        elements.should have_at_most(1).items
      end
      get rails_admin_list_path(:model_name => "player")
      response.should have_tag("#contentMainModules > table > .infoRow") do |elements|
        elements.should have_at_most(1).items
      end

      # Reset
      RailsAdmin::Config.models do
        list do
          items_per_page RailsAdmin::Config::Sections::List.default_items_per_page
        end
      end
    end

    it "should be configurable per model" do
      RailsAdmin.config League do
        list do
          items_per_page 1
        end
      end
      get rails_admin_list_path(:model_name => "league")
      response.should have_tag("#contentMainModules > table > .infoRow") do |elements|
        elements.should have_at_most(1).items
      end
      get rails_admin_list_path(:model_name => "player")
      response.should have_tag("#contentMainModules > table > .infoRow") do |elements|
        elements.should have_at_most(2).items
      end

      # Reset
      RailsAdmin.config League do
        list do
          items_per_page RailsAdmin::Config::Sections::List.default_items_per_page
        end
      end
    end

    it "should be globally configurable and overrideable per model" do
      RailsAdmin::Config.models do
        list do
          items_per_page 20
        end
      end
      RailsAdmin.config League do
        list do
          items_per_page 1
        end
      end
      get rails_admin_list_path(:model_name => "league")
      response.should have_tag("#contentMainModules > table > .infoRow") do |elements|
        elements.should have_at_most(1).items
      end
      get rails_admin_list_path(:model_name => "player")
      response.should have_tag("#contentMainModules > table > .infoRow") do |elements|
        elements.should have_at_most(2).items
      end

      # Reset
      RailsAdmin::Config.models do
        list do
          items_per_page RailsAdmin::Config::Sections::List.default_items_per_page
        end
      end
    end
  end

  describe "items' fields" do

    it "should show all by default" do
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements[1].should contain("ID")
        elements[2].should contain("CREATED AT")
        elements[3].should contain("UPDATED AT")
        elements[4].should contain("NAME")
      end
    end

    it "should appear in order defined" do
      RailsAdmin.config Fan do
        list do
          field :updated_at
          field :name
          field :id
          field :created_at
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements[1].should contain("UPDATED AT")
        elements[2].should contain("NAME")
        elements[3].should contain("ID")
        elements[4].should contain("CREATED AT")
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should only list the defined fields if some fields are defined" do
      RailsAdmin.config Fan do
        list do
          field :id
          field :name
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements.should contain("ID")
        elements.should contain("NAME")
        elements.should_not contain("CREATED AT")
        elements.should_not contain("UPDATED AT")
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should be renameable" do
      RailsAdmin.config Fan do
        list do
          field :id do
            label "IDENTIFIER"
          end
          field :name
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements[1].should contain("IDENTIFIER")
        elements[2].should contain("NAME")
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should be renameable by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            label { "#{label} (DATETIME)" }
          end
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements[1].should contain("ID")
        elements[2].should contain("CREATED AT (DATETIME)")
        elements[3].should contain("UPDATED AT (DATETIME)")
        elements[4].should contain("NAME")
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should be globally renameable by type" do
      RailsAdmin::Config.models do
        list do
          fields_of_type :datetime do
            label { "#{label} (DATETIME)" }
          end
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements[1].should contain("ID")
        elements[2].should contain("CREATED AT (DATETIME)")
        elements[3].should contain("UPDATED AT (DATETIME)")
        elements[4].should contain("NAME")
      end

      # Reset
      RailsAdmin::Config.reset
    end

    it "should be sortable by default" do
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements[1].should have_tag("a")
        elements[2].should have_tag("a")
        elements[3].should have_tag("a")
        elements[4].should have_tag("a")
      end
    end

    it "should have option to disable sortability" do
      RailsAdmin.config Fan do
        list do
          field :id do
            sortable false
          end
          field :name
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements[1].should_not have_tag("a")
        elements[2].should have_tag("a")
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should have option to disable sortability by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            sortable false
          end
          field :id
          field :name
          field :created_at
          field :updated_at
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements[1].should have_tag("a")
        elements[2].should have_tag("a")
        elements[3].should_not have_tag("a")
        elements[4].should_not have_tag("a")
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should have option to disable sortability by type globally" do
      RailsAdmin::Config.models do
        list do
          fields_of_type :datetime do
            sortable false
          end
          field :id
          field :name
          field :created_at
          field :updated_at
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements[1].should have_tag("a")
        elements[2].should have_tag("a")
        elements[3].should_not have_tag("a")
        elements[4].should_not have_tag("a")
      end

      # Reset
      RailsAdmin::Config.reset
    end

    it "should have option to hide fields by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            hide
          end
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements.should contain("ID")
        elements.should contain("NAME")
        elements.should_not contain("CREATED AT")
        elements.should_not contain("UPDATED AT")
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should have option to hide fields by type globally" do
      RailsAdmin::Config.models do
        list do
          fields_of_type :datetime do
            hide
          end
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag("#moduleHeader > th") do |elements|
        elements.should contain("ID")
        elements.should contain("NAME")
        elements.should_not contain("CREATED AT")
        elements.should_not contain("UPDATED AT")
      end

      # Reset
      RailsAdmin::Config.reset
    end

    it "should have option to customize css class name" do
      RailsAdmin.config Fan do
        list do
          field :id do
            column_css_class "customClass"
          end
          field :name
        end
      end

      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag("#moduleHeader > th:nth-child(2).customClassHeader")
      response.should have_tag("#moduleHeader > th:nth-child(3).smallStringHeader")
      response.should have_tag(".infoRow") do |elements|
        elements[0].should have_tag("td:nth-child(2).customClassRow")
        elements[0].should have_tag("td:nth-child(3).smallStringRow")
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should have option to customize css class name by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            column_css_class "customClass"
          end
        end
      end

      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag("#moduleHeader > th:nth-child(3).customClassHeader")
      response.should have_tag("#moduleHeader > th:nth-child(4).customClassHeader")
      response.should have_tag("#moduleHeader > th:nth-child(5).smallStringHeader")
      response.should have_tag(".infoRow") do |elements|
        elements[0].should have_tag("td:nth-child(3).customClassRow")
        elements[0].should have_tag("td:nth-child(4).customClassRow")
        elements[0].should have_tag("td:nth-child(5).smallStringRow")
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should have option to customize css class name by type globally" do
      RailsAdmin::Config.models do
        list do
          fields_of_type :datetime do
            column_css_class "customClass"
          end
        end
      end

      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag("#moduleHeader > th:nth-child(3).customClassHeader")
      response.should have_tag("#moduleHeader > th:nth-child(4).customClassHeader")
      response.should have_tag("#moduleHeader > th:nth-child(5).smallStringHeader")
      response.should have_tag(".infoRow") do |elements|
        elements[0].should have_tag("td:nth-child(3).customClassRow")
        elements[0].should have_tag("td:nth-child(4).customClassRow")
        elements[0].should have_tag("td:nth-child(5).smallStringRow")
      end

      # Reset
      RailsAdmin::Config.reset
    end

    it "should have option to customize column width" do
      RailsAdmin.config Fan do
        list do
          field :id do
            column_width 200
          end
          field :name
          field :created_at
          field :updated_at
        end
      end

      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag("style") {|css| css.should contain(/\.idHeader[^{]*\{[^a-z]*width:[^\d]*2\d{2}px;[^{]*\}/) }
      response.should have_tag("style") {|css| css.should contain(/\.idRow[^{]*\{[^a-z]*width:[^\d]*2\d{2}px;[^{]*\}/) }

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should have option to customize output formatting" do
      RailsAdmin.config Fan do
        list do
          field :id
          field :name do
            formatted_value do
              value.to_s.upcase
            end
          end
          field :created_at
          field :updated_at
        end
      end

      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag(".infoRow") do |elements|
        elements[0].should have_tag("td:nth-child(3)") {|li| li.should contain("FAN II") }
        elements[1].should have_tag("td:nth-child(3)") {|li| li.should contain("FAN I") }
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should have a simple option to customize output formatting of date fields" do
      RailsAdmin.config Fan do
        list do
          field :id
          field :name
          field :created_at do
            date_format :short
          end
          field :updated_at
        end
      end

      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag(".infoRow") do |elements|
        elements[0].should have_tag("td:nth-child(4)") do |li|
          li.should contain(/\d{2} \w{3} \d{1,2}:\d{1,2}/)
        end
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end
          it "should have option to customize output formatting of date fields" do
      RailsAdmin.config Fan do
        list do
          field :id
          field :name
          field :created_at do
            strftime_format "%Y-%m-%d"
          end
          field :updated_at
        end
      end

      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
      RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag(".infoRow") do |elements|
        elements[0].should have_tag("td:nth-child(4)") do |li|
          li.should contain(/\d{4}-\d{2}-\d{2}/)
        end
      end

      # Reset
      RailsAdmin::Config.reset Fan
    end

    it "should allow addition of virtual fields (object methods)" do
      RailsAdmin.config Team do
        list do
          field :id
          field :name
          field :player_names_truncated
        end
      end

      team = RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team I", :manager => "Manager I", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)

      RailsAdmin::AbstractModel.new("Player").create(:name => 'Player I', :number => 1, :team => team)
      RailsAdmin::AbstractModel.new("Player").create(:name => 'Player II', :number => 2, :team => team)
      RailsAdmin::AbstractModel.new("Player").create(:name => 'Player III', :number => 3, :team => team)

      get rails_admin_list_path(:model_name => "team")

      response.should have_tag(".infoRow") do |elements|
        elements[0].should have_tag("td:nth-child(4)") {|li| li.should contain("Player I, Player II, Player III") }
      end

      # Reset
      RailsAdmin::Config.reset Team
    end
  end
end
