require 'spec_helper'

describe "RailsAdmin Config DSL List Section" do

  subject { page }

  describe "css hooks" do
    it "is present" do
      RailsAdmin.config Team do
        list do
          field :name
        end
      end
      FactoryGirl.create :team
      visit index_path(:model_name => "team")
      should have_selector("th.header.string_type.name_field")
      should have_selector("td.string_type.name_field")
    end
  end


  describe "number of items per page" do

    before(:each) do
      2.times.each do
        FactoryGirl.create :league
        FactoryGirl.create :player
      end
    end

    it "is configurable per model" do
      RailsAdmin.config League do
        list do
          items_per_page 1
        end
      end
      visit index_path(:model_name => "league")
      should have_selector("tbody tr", :count => 1)
      visit index_path(:model_name => "player")
      should have_selector("tbody tr", :count => 2)
    end
  end

  describe "items' fields" do

    it "shows all by default" do
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Id", "Created at", "Updated at", "His Name", "Teams"]
    end

    it "hides some fields on demand with a block" do
      RailsAdmin.config Fan do
        list do
          exclude_fields_if do
            type == :datetime
          end
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Id", "His Name", "Teams"]
    end

    it "hides some fields on demand with fields list" do
      RailsAdmin.config Fan do
        list do
          exclude_fields :created_at, :updated_at
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Id", "His Name", "Teams"]
    end

    it "adds some fields on demand with a block" do
      RailsAdmin.config Fan do
        list do
          include_fields_if do
            type != :datetime
          end
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Id", "His Name", "Teams"]
    end

    it "shows some fields on demand with fields list, respect ordering and configure them" do
      RailsAdmin.config Fan do
        list do
          fields :name, PK_COLUMN do
            label do
              "Modified #{label}"
            end
          end
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Modified Id", "Modified His Name"]
    end

    it "shows all fields if asked" do
      RailsAdmin.config Fan do
        list do
          include_all_fields
          field PK_COLUMN
          field :name
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Id", "Created at", "Updated at", "His Name", "Teams"]
    end

    it "appears in order defined" do
      RailsAdmin.config Fan do
        list do
          field :updated_at
          field :name
          field PK_COLUMN
          field :created_at
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to eq(["Updated at", "His Name", "Id", "Created at"])
    end

    it "only lists the defined fields if some fields are defined" do
      RailsAdmin.config Fan do
        list do
          field PK_COLUMN
          field :name
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to eq(["Id", "His Name"])
      should have_no_selector("th:nth-child(4).header")
    end

    it "delegates the label option to the ActiveModel API" do
      RailsAdmin.config Fan do
        list do
          field :name
        end
      end
      visit index_path(:model_name => "fan")
      expect(find("th:nth-child(2)")).to have_content("His Name")
    end

    it "is renameable" do
      RailsAdmin.config Fan do
        list do
          field PK_COLUMN do
            label "Identifier"
          end
          field :name
        end
      end
      visit index_path(:model_name => "fan")
      expect(find("th:nth-child(2)")).to have_content("Identifier")
      expect(find("th:nth-child(3)")).to have_content("His Name")
    end

    it "is renameable by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            label { "#{label} (datetime)" }
          end
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Id", "Created at (datetime)", "Updated at (datetime)", "His Name", "Teams"]
    end

    it "is globally renameable by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            label { "#{label} (datetime)" }
          end
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Id", "Created at (datetime)", "Updated at (datetime)", "His Name", "Teams"]
    end

    it "is sortable by default" do
      visit index_path(:model_name => "fan")
      should have_selector("th:nth-child(2).header")
      should have_selector("th:nth-child(3).header")
      should have_selector("th:nth-child(4).header")
      should have_selector("th:nth-child(5).header")
    end

    it "has option to disable sortability" do
      RailsAdmin.config Fan do
        list do
          field PK_COLUMN do
            sortable false
          end
          field :name
        end
      end
      visit index_path(:model_name => "fan")
      should have_no_selector("th:nth-child(2).header")
      should have_selector("th:nth-child(3).header")
    end

    it "has option to disable sortability by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            sortable false
          end
          field PK_COLUMN
          field :name
          field :created_at
          field :updated_at
        end
      end
      visit index_path(:model_name => "fan")
      should have_selector("th:nth-child(2).header")
      should have_selector("th:nth-child(3).header")
      should have_no_selector("th:nth-child(4).header")
      should have_no_selector("th:nth-child(5).header")
    end

    it "has option to disable sortability by type globally" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            sortable false
          end
          field PK_COLUMN
          field :name
          field :created_at
          field :updated_at
        end
      end
      visit index_path(:model_name => "fan")
      should have_selector("th:nth-child(2).header")
      should have_selector("th:nth-child(3).header")
      should have_no_selector("th:nth-child(4).header")
      should have_no_selector("th:nth-child(5).header")
    end

    it "has option to hide fields by type" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            hide
          end
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Id", "His Name", "Teams"]
    end

    it "has option to hide fields by type globally" do
      RailsAdmin.config Fan do
        list do
          fields_of_type :datetime do
            hide
          end
        end
      end
      visit index_path(:model_name => "fan")
      expect(all("th").map(&:text).delete_if{|t| /^\n*$/ =~ t }).
        to match_array ["Id", "His Name", "Teams"]
    end

    it "has option to customize column width" do
      RailsAdmin.config Fan do
        list do
          field PK_COLUMN do
            column_width 200
          end
          field :name
          field :created_at
          field :updated_at
        end
      end
      @fans = 2.times.map { FactoryGirl.create :fan }
      visit index_path(:model_name => "fan")
      # NOTE: Capybara really doesn't want us to look at invisible text. This test
      # could break at any moment.
      expect(find('style').native.text).to include("#list th.#{PK_COLUMN}_field")
      expect(find('style').native.text).to include("#list td.#{PK_COLUMN}_field")
    end

    it "has option to customize output formatting" do
      RailsAdmin.config Fan do
        list do
          field PK_COLUMN
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
      visit index_path(:model_name => "fan")
      expect(find('tbody tr:nth-child(1) td:nth-child(3)')).to have_content(@fans[1].name.upcase)
      expect(find('tbody tr:nth-child(2) td:nth-child(3)')).to have_content(@fans[0].name.upcase)
    end

    it "has a simple option to customize output formatting of date fields" do
      RailsAdmin.config Fan do
        list do
          field PK_COLUMN
          field :name
          field :created_at do
            date_format :short
          end
          field :updated_at
        end
      end
      @fans = 2.times.map { FactoryGirl.create :fan }
      visit index_path(:model_name => "fan")
      should have_selector("tbody tr:nth-child(1) td:nth-child(4)", :text => /\d{2} \w{3} \d{1,2}:\d{1,2}/)
    end

    it "has option to customize output formatting of date fields" do
      RailsAdmin.config Fan do
        list do
          field PK_COLUMN
          field :name
          field :created_at do
            strftime_format "%Y-%m-%d"
          end
          field :updated_at
        end
      end
      @fans = 2.times.map { FactoryGirl.create :fan }
      visit index_path(:model_name => "fan")
      should have_selector("tbody tr:nth-child(1) td:nth-child(4)", :text => /\d{4}-\d{2}-\d{2}/)
    end

    it "allows addition of virtual fields (object methods)" do
      RailsAdmin.config Team do
        list do
          field PK_COLUMN
          field :name
          field :player_names_truncated
        end
      end
      @team = FactoryGirl.create :team
      @players = 2.times.map { FactoryGirl.create :player, :team => @team }
      visit index_path(:model_name => "team")
      expect(find('tbody tr:nth-child(1) td:nth-child(4)')).to have_content(@players.collect(&:name).join(", "))
    end
  end

  # sort_by and sort_reverse options
  describe "default sorting" do
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

    before(:each) { @players = players.map{|h| Player.create(h) }}

    context "should be configurable" do
      it "per model" do
        RailsAdmin.config Player do
          list do
            sort_by :created_at
            sort_reverse true
            field :name
          end
        end
        visit index_path(:model_name => "player")
        player_names_by_date.reverse.each_with_index do |name, i|
          expect(find("tbody tr:nth-child(#{i + 1})")).to have_content(name)
        end
      end
    end

    it "has reverse direction by default" do
      RailsAdmin.config Player do
        list do
          sort_by :created_at
          field :name
        end
      end
      visit index_path(:model_name => "player")
      player_names_by_date.reverse.each_with_index do |name, i|
        expect(find("tbody tr:nth-child(#{i + 1})")).to have_content(name)
      end
    end

    it "allows change default direction" do
      RailsAdmin.config Player do
        list do
          sort_by :created_at
          sort_reverse false
          field :name
        end
      end
      visit index_path(:model_name => "player")
      player_names_by_date.each_with_index do |name, i|
        expect(find("tbody tr:nth-child(#{i + 1})")).to have_content(name)
      end
    end
  end

  describe "embedded model", :mongoid => true do
    it "does not show link to individual object's page" do
      RailsAdmin.config FieldTest do
        list do
          field :embeds
        end
      end
      @record = FactoryGirl.create :field_test
      2.times.each{|i| @record.embeds.create :name => "embed #{i}"}
      visit index_path(:model_name => "field_test")
      should_not have_link('embed 0')
      should_not have_link('embed 1')
    end
  end
end
