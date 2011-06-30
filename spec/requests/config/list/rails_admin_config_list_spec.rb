require 'spec_helper'

describe "RailsAdmin Config DSL List Section" do

  describe "number of items per page" do

    before(:each) do
      2.times.each do
        FactoryGirl.create :league
        FactoryGirl.create :player
      end
    end

    it "should be configurable" do
      RailsAdmin::Config.models do
        list do
          items_per_page 1
        end
      end
      get rails_admin_list_path(:model_name => "league")
      response.should have_tag(".grid tbody tr") do |elements|
        elements.should have_at_most(1).items
      end
      get rails_admin_list_path(:model_name => "player")
      response.should have_tag(".grid tbody tr") do |elements|
        elements.should have_at_most(1).items
      end
    end

    it "should be configurable per model" do
      RailsAdmin.config League do
        list do
          items_per_page 1
        end
      end
      get rails_admin_list_path(:model_name => "league")
      response.should have_tag(".grid tbody tr") do |elements|
        elements.should have_at_most(1).items
      end
      get rails_admin_list_path(:model_name => "player")
      response.should have_tag(".grid tbody tr") do |elements|
        elements.should have_at_most(2).items
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
      response.should have_tag(".grid tbody tr") do |elements|
        elements.should have_at_most(1).items
      end
      get rails_admin_list_path(:model_name => "player")
      response.should have_tag(".grid tbody tr") do |elements|
        elements.should have_at_most(2).items
      end
    end
  end

  describe "items' fields" do

    it "should show all by default" do
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag(".grid th") do |elements|
        elements[1].should contain("ID")
        elements[2].should contain("CREATED AT")
        elements[3].should contain("UPDATED AT")
        elements[4].should contain("HIS NAME")
      end
    end
    
    it "should hide some fields on demand with a block" do
      RailsAdmin.config Fan do
        list do
          exclude_fields_if do
            type == :datetime
          end
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag(".grid th") do |elements|
        elements[1].should contain("ID")
        elements[2].should contain("HIS NAME")
      end
    end
    
    it "should hide some fields on demand with fields list" do
      RailsAdmin.config Fan do
        list do
          exclude_fields :created_at, :updated_at
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag(".grid th") do |elements|
        elements[1].should contain("ID")
        elements[2].should contain("HIS NAME")
      end
    end
    
    it "should add some fields on demand with a block" do
      RailsAdmin.config Fan do
        list do
          include_fields_if do
            type != :datetime
          end
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag(".grid th") do |elements|
        elements[1].should contain("ID")
        elements[2].should contain("HIS NAME")
      end
    end

    it "should show some fields on demand with fields list, respect ordering and configure them" do
      RailsAdmin.config Fan do
        list do
          fields :name, :id do
            label do
              "MODIFIED #{label}"
            end
          end
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag(".grid th") do |elements|
        elements[1].should contain("MODIFIED HIS NAME")
        elements[2].should contain("MODIFIED ID")
      end
    end
    
    it "should show all fields if asked" do
      RailsAdmin.config Fan do
        list do
          include_all_fields
          field :id
          field :name
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag(".grid th") do |elements|
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
      response.should have_tag(".grid th") do |elements|
        elements[2].should contain("UPDATED AT")
        elements[3].should contain("NAME")
        elements[4].should contain("ID")
        elements[5].should contain("CREATED AT")
      end
    end

    it "should only list the defined fields if some fields are defined" do
      RailsAdmin.config Fan do
        list do
          field :id
          field :name
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag(".grid th") do |elements|
        elements.should contain("ID")
        elements.should contain("NAME")
        elements.should_not contain("CREATED AT")
        elements.should_not contain("UPDATED AT")
      end
    end

    it "should delegate the label option to the ActiveModel API" do
      RailsAdmin.config Fan do
        list do
          field :name
        end
      end
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag(".grid th") do |elements|
        elements[2].should contain("HIS NAME")
      end
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
      response.should have_tag(".grid th") do |elements|
        elements[2].should contain("IDENTIFIER")
        elements[3].should contain("NAME")
      end
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
      response.should have_tag(".grid th") do |elements|
        elements[2].should contain("ID")
        elements[3].should contain("CREATED AT (DATETIME)")
        elements[4].should contain("UPDATED AT (DATETIME)")
        elements[5].should contain("NAME")
      end
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
      response.should have_tag(".grid th") do |elements|
        elements[2].should contain("ID")
        elements[3].should contain("CREATED AT (DATETIME)")
        elements[4].should contain("UPDATED AT (DATETIME)")
        elements[5].should contain("NAME")
      end
    end

    it "should be sortable by default" do
      get rails_admin_list_path(:model_name => "fan")
      response.should have_tag(".grid th") do |elements|
        elements[2].should have_tag("a")
        elements[3].should have_tag("a")
        elements[4].should have_tag("a")
        elements[5].should have_tag("a")
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
      response.should have_tag(".grid th") do |elements|
        elements[2].should_not have_tag("a")
        elements[3].should have_tag("a")
      end
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
      response.should have_tag(".grid th") do |elements|
        elements[2].should have_tag("a")
        elements[3].should have_tag("a")
        elements[4].should_not have_tag("a")
        elements[5].should_not have_tag("a")
      end
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
      response.should have_tag(".grid th") do |elements|
        elements[2].should have_tag("a")
        elements[3].should have_tag("a")
        elements[4].should_not have_tag("a")
        elements[5].should_not have_tag("a")
      end
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
      response.should have_tag(".grid th") do |elements|
        elements.should contain("ID")
        elements.should contain("NAME")
        elements.should_not contain("CREATED AT")
        elements.should_not contain("UPDATED AT")
      end
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
      response.should have_tag(".grid th") do |elements|
        elements.should contain("ID")
        elements.should contain("NAME")
        elements.should_not contain("CREATED AT")
        elements.should_not contain("UPDATED AT")
      end
    end

    it "should have option to customize css class name" do
      RailsAdmin.config Fan do
        list do
          field :id do
            css_class "customClass"
          end
          field :name
        end
      end

      @fans = 2.times.map { FactoryGirl.create :fan }

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag(".grid") do |table|
        table.should have_tag("th:nth-child(3).customClass")
        table.should have_tag("th:nth-child(4).string")
        table.should have_tag("tbody tr") do |rows|
          rows[0].should have_tag("td:nth-child(3).customClass")
          rows[0].should have_tag("td:nth-child(4).string")
        end
      end
    end

    it "should have option to customize css class name by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            css_class "customClass"
          end
        end
      end

      @fans = 2.times.map { FactoryGirl.create :fan }

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag(".grid") do |table|
        table.should have_tag("th:nth-child(4).customClass")
        table.should have_tag("th:nth-child(5).customClass")
        table.should have_tag("th:nth-child(6).string")
        table.should have_tag("tbody tr") do |rows|
          rows[0].should have_tag("td:nth-child(4).customClass")
          rows[0].should have_tag("td:nth-child(5).customClass")
          rows[0].should have_tag("td:nth-child(6).string")
        end
      end
    end

    it "should have option to customize css class name by type globally" do
      RailsAdmin::Config.models do
        list do
          fields_of_type :datetime do
            css_class "customClass"
          end
        end
      end

      @fans = 2.times.map { FactoryGirl.create :fan }

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag(".grid") do |table|
        table.should have_tag("th:nth-child(4).customClass")
        table.should have_tag("th:nth-child(5).customClass")
        table.should have_tag("th:nth-child(6).string")
        table.should have_tag("tbody tr") do |rows|
          rows[0].should have_tag("td:nth-child(4).customClass")
          rows[0].should have_tag("td:nth-child(5).customClass")
          rows[0].should have_tag("td:nth-child(6).string")
        end
      end
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

      @fans = 2.times.map { FactoryGirl.create :fan }

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag("style") {|css| css.should contain(/\.grid thead \.id[^{]*\{[^a-z]*width:[^\d]*2\d{2}px;[^{]*\}/) }
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

      @fans = 2.times.map { FactoryGirl.create :fan }

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag(".grid tbody tr") do |elements|
        elements[0].should have_tag("td:nth-child(4)") {|li| li.should contain(@fans[1].name.upcase) }
        elements[1].should have_tag("td:nth-child(4)") {|li| li.should contain(@fans[0].name.upcase) }
      end
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

      @fans = 2.times.map { FactoryGirl.create :fan }

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag(".grid tbody tr") do |elements|
        elements[0].should have_tag("td:nth-child(5)") do |li|
          li.should contain(/\d{2} \w{3} \d{1,2}:\d{1,2}/)
        end
      end
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

      @fans = 2.times.map { FactoryGirl.create :fan }

      get rails_admin_list_path(:model_name => "fan")

      response.should have_tag(".grid tbody tr") do |elements|
        elements[0].should have_tag("td:nth-child(5)") do |li|
          li.should contain(/\d{4}-\d{2}-\d{2}/)
        end
      end
    end

    it "should allow addition of virtual fields (object methods)" do
      RailsAdmin.config Team do
        list do
          field :id
          field :name
          field :player_names_truncated
        end
      end

      @team = FactoryGirl.create :team
      @players = 2.times.map { FactoryGirl.create :player, :team => @team }

      get rails_admin_list_path(:model_name => "team")

      response.should have_tag(".grid tbody tr") do |elements|
        elements[0].should have_tag("td:nth-child(5)") {|li| li.should contain(@players.collect(&:name).join(", ")) }
      end
    end
  end

  # sort_by and sort_reverse options
  describe "default sorting" do
    before(:each) do
      RailsAdmin.config(Player){ list { field :name } }
    end

    let(:today){ Date.today }
    let(:players) do
      [{ :name => "Jackie Robinson",  :created_at => today,            :team_id => rand(99999), :number => 42 },
       { :name => "Deibinson Romero", :created_at => (today - 2.days), :team_id => rand(99999), :number => 13 },
       { :name => "Sandy Koufax",     :created_at => (today - 1.days), :team_id => rand(99999), :number => 32 }]
    end
    let(:leagues) do
      [{ :name => 'American',      :created_at => (today - 1.day) },
       { :name => 'Florida State', :created_at => (today - 2.days)},
       { :name => 'National',      :created_at => today }]
    end
    let(:player_names_by_date){ players.sort_by{|p| p[:created_at]}.map{|p| p[:name]} }
    let(:league_names_by_date){ leagues.sort_by{|l| l[:created_at]}.map{|l| l[:name]} }

    before(:each) { @players = RailsAdmin::AbstractModel.new("Player").create(players) }

    context "should be configurable" do
      it "globaly" do
        RailsAdmin.config do |config|
          config.models do
            list do
              sort_by :created_at
              sort_reverse true
            end
          end
        end

        get rails_admin_list_path(:model_name => "player")
        response.should have_tag(".grid tbody tr") do |elements|
          player_names_by_date.reverse.each_with_index do |name, i|
            elements[i].should contain(name)
          end
        end
      end

      it "per model" do
        RailsAdmin.config Player do
          list do
            sort_by :created_at
            sort_reverse true
          end
        end
        
        get rails_admin_list_path(:model_name => "player")
        response.should have_tag(".grid tbody tr") do |elements|
          player_names_by_date.reverse.each_with_index do |name, i|
            elements[i].should contain(name)
          end
        end
      end

      it "globaly and overrideable per model" do
        RailsAdmin::AbstractModel.new("League").create(leagues)

        RailsAdmin::Config.models do
          list do
            sort_by :created_at
            sort_reverse true
          end
        end

        RailsAdmin.config Player do
          list do
            sort_by :id
            sort_reverse true
          end
        end

        get rails_admin_list_path(:model_name => "league")
        response.should have_tag(".grid tbody tr") do |elements|
          league_names_by_date.reverse.each_with_index do |name, i|
            elements[i].should contain(name)
          end
        end

        get rails_admin_list_path(:model_name => "player")
        response.should have_tag(".grid tbody tr") do |elements|
          @players.sort_by{|p| p[:id]}.map{|p| p[:name]}.reverse.each_with_index do |name, i|
            elements[i].should contain(name)
          end
        end
      end
    end

    it "should have reverse direction by default" do
      RailsAdmin.config Player do
        list do
          sort_by :created_at
        end
      end

      get rails_admin_list_path(:model_name => "player")
      response.should have_tag(".grid tbody tr") do |elements|
        player_names_by_date.reverse.each_with_index do |name, i|
          elements[i].should contain(name)
        end
      end
    end

    it "should allow change default direction" do
      RailsAdmin.config Player do
        list do
          sort_by :created_at
          sort_reverse false
        end
      end

      get rails_admin_list_path(:model_name => "player")
      response.should have_tag(".grid tbody tr") do |elements|
        player_names_by_date.each_with_index do |name, i|
          elements[i].should contain(name)
        end
      end
    end
  end
end
