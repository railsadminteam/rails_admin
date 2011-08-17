require 'spec_helper'

describe "RailsAdmin Config DSL List Section" do

  subject { page }

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
      visit list_path(:model_name => "league")
      should have_selector(".grid tbody tr", :count => 1)
      visit list_path(:model_name => "player")
      should have_selector(".grid tbody tr", :count => 1)
    end

    it "should be configurable per model" do
      RailsAdmin.config League do
        list do
          items_per_page 1
        end
      end
      visit list_path(:model_name => "league")
      should have_selector(".grid tbody tr", :count => 1)
      visit list_path(:model_name => "player")
      should have_selector(".grid tbody tr", :count => 2)
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
      visit list_path(:model_name => "league")
      should have_selector(".grid tbody tr", :count => 1)
      visit list_path(:model_name => "player")
      should have_selector(".grid tbody tr", :count => 2)
    end
  end

  describe "items' fields" do

    it "should show all by default" do
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "Created at")
      should have_selector(".grid th:nth-child(5)", :text => "Updated at")
      should have_selector(".grid th:nth-child(6)", :text => "His Name")
    end

    it "should hide some fields on demand with a block" do
      RailsAdmin.config Fan do
        list do
          exclude_fields_if do
            type == :datetime
          end
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "His Name")
    end

    it "should hide some fields on demand with fields list" do
      RailsAdmin.config Fan do
        list do
          exclude_fields :created_at, :updated_at
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "His Name")
    end

    it "should add some fields on demand with a block" do
      RailsAdmin.config Fan do
        list do
          include_fields_if do
            type != :datetime
          end
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "His Name")
    end

    it "should show some fields on demand with fields list, respect ordering and configure them" do
      RailsAdmin.config Fan do
        list do
          fields :name, :id do
            label do
              "Modified #{label}"
            end
          end
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Modified His Name")
      should have_selector(".grid th:nth-child(4)", :text => "Modified Id")
    end

    it "should show all fields if asked" do
      RailsAdmin.config Fan do
        list do
          include_all_fields
          field :id
          field :name
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "Created at")
      should have_selector(".grid th:nth-child(5)", :text => "Updated at")
      should have_selector(".grid th:nth-child(6)", :text => "His Name")
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
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Updated at")
      should have_selector(".grid th:nth-child(4)", :text => "His Name")
      should have_selector(".grid th:nth-child(5)", :text => "Id")
      should have_selector(".grid th:nth-child(6)", :text => "Created at")
    end

    it "should only list the defined fields if some fields are defined" do
      RailsAdmin.config Fan do
        list do
          field :id
          field :name
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "His Name")
      should have_no_selector(".grid th:nth-child(5)", :text => "Created at")
      should have_no_selector(".grid th:nth-child(6)", :text => "Updated at")
    end

    it "should delegate the label option to the ActiveModel API" do
      RailsAdmin.config Fan do
        list do
          field :name
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "His Name")
    end

    it "should be renameable" do
      RailsAdmin.config Fan do
        list do
          field :id do
            label "Identifier"
          end
          field :name
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Identifier")
      should have_selector(".grid th:nth-child(4)", :text => "His Name")
    end

    it "should be renameable by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            label { "#{label} (datetime)" }
          end
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "Created at (datetime)")
      should have_selector(".grid th:nth-child(5)", :text => "Updated at (datetime)")
      should have_selector(".grid th:nth-child(6)", :text => "His Name")
    end

    it "should be globally renameable by type" do
      RailsAdmin::Config.models do
        list do
          fields_of_type :datetime do
            label { "#{label} (datetime)" }
          end
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "Created at (datetime)")
      should have_selector(".grid th:nth-child(5)", :text => "Updated at (datetime)")
      should have_selector(".grid th:nth-child(6)", :text => "His Name")
    end

    it "should be sortable by default" do
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3) a")
      should have_selector(".grid th:nth-child(4) a")
      should have_selector(".grid th:nth-child(5) a")
      should have_selector(".grid th:nth-child(6) a")
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
      visit list_path(:model_name => "fan")
      should have_no_selector(".grid th:nth-child(3) a")
      should have_selector(".grid th:nth-child(4) a")
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
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3) a")
      should have_selector(".grid th:nth-child(4) a")
      should have_no_selector(".grid th:nth-child(5) a")
      should have_no_selector(".grid th:nth-child(6) a")
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
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3) a")
      should have_selector(".grid th:nth-child(4) a")
      should have_no_selector(".grid th:nth-child(5) a")
      should have_no_selector(".grid th:nth-child(6) a")
    end

    it "should have option to hide fields by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            hide
          end
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "His Name")
      should have_no_selector(".grid th:nth-child(5)", :text => "Created at")
      should have_no_selector(".grid th:nth-child(6)", :text => "Updated at")
    end

    it "should have option to hide fields by type globally" do
      RailsAdmin::Config.models do
        list do
          fields_of_type :datetime do
            hide
          end
        end
      end
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3)", :text => "Id")
      should have_selector(".grid th:nth-child(4)", :text => "His Name")
      should have_no_selector(".grid th:nth-child(5)", :text => "Created at")
      should have_no_selector(".grid th:nth-child(6)", :text => "Updated at")
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
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(3).customClass")
      should have_selector(".grid th:nth-child(4).string")
      should have_selector(".grid td:nth-child(3).customClass")
      should have_selector(".grid td:nth-child(4).string")
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
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(4).customClass")
      should have_selector(".grid th:nth-child(5).customClass")
      should have_selector(".grid th:nth-child(6).string")
      should have_selector(".grid td:nth-child(4).customClass")
      should have_selector(".grid td:nth-child(5).customClass")
      should have_selector(".grid td:nth-child(6).string")
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
      visit list_path(:model_name => "fan")
      should have_selector(".grid th:nth-child(4).customClass")
      should have_selector(".grid th:nth-child(5).customClass")
      should have_selector(".grid th:nth-child(6).string")
      should have_selector(".grid td:nth-child(4).customClass")
      should have_selector(".grid td:nth-child(5).customClass")
      should have_selector(".grid td:nth-child(6).string")
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
      visit list_path(:model_name => "fan")
      should have_selector("style", :text => /\.grid thead \.id[^{]*\{[^a-z]*width:[^\d]*2\d{2}px;[^{]*\}/)
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
      visit list_path(:model_name => "fan")
      should have_selector(".grid tbody tr:nth-child(1) td:nth-child(4)", :text => @fans[1].name.upcase)
      should have_selector(".grid tbody tr:nth-child(2) td:nth-child(4)", :text => @fans[0].name.upcase)
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
      visit list_path(:model_name => "fan")
      should have_selector(".grid tbody tr:nth-child(1) td:nth-child(5)", :text => /\d{2} \w{3} \d{1,2}:\d{1,2}/)
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
      visit list_path(:model_name => "fan")
      should have_selector(".grid tbody tr:nth-child(1) td:nth-child(5)", :text => /\d{4}-\d{2}-\d{2}/)
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
      visit list_path(:model_name => "team")
      should have_selector(".grid tbody tr:nth-child(1) td:nth-child(5)", :text => @players.collect(&:name).join(", "))
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
        visit list_path(:model_name => "player")
        player_names_by_date.reverse.each_with_index do |name, i|
          should have_selector(".grid tbody tr:nth-child(#{i + 1})", :text => name)
        end
      end

      it "per model" do
        RailsAdmin.config Player do
          list do
            sort_by :created_at
            sort_reverse true
          end
        end
        visit list_path(:model_name => "player")
        player_names_by_date.reverse.each_with_index do |name, i|
          should have_selector(".grid tbody tr:nth-child(#{i + 1})", :text => name)
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

        visit list_path(:model_name => "league")
        league_names_by_date.reverse.each_with_index do |name, i|
          should have_selector(".grid tbody tr:nth-child(#{i + 1})", :text => name)
        end

        visit list_path(:model_name => "player")
        @players.sort_by{|p| p[:id]}.map{|p| p[:name]}.reverse.each_with_index do |name, i|
          should have_selector(".grid tbody tr:nth-child(#{i + 1})", :text => name)
        end
      end
    end

    it "should have reverse direction by default" do
      RailsAdmin.config Player do
        list do
          sort_by :created_at
        end
      end
      visit list_path(:model_name => "player")
      player_names_by_date.reverse.each_with_index do |name, i|
        should have_selector(".grid tbody tr:nth-child(#{i + 1})", :text => name)
      end
    end

    it "should allow change default direction" do
      RailsAdmin.config Player do
        list do
          sort_by :created_at
          sort_reverse false
        end
      end
      visit list_path(:model_name => "player")
      player_names_by_date.each_with_index do |name, i|
        should have_selector(".grid tbody tr:nth-child(#{i + 1})", :text => name)
      end
    end
  end
end
