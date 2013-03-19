require 'spec_helper'

describe "RailsAdmin Config DSL Show Section" do
  subject { page }
  let(:team) { FactoryGirl.create :team }

  def do_request
    # tests were done with compact_show_view being false
    RailsAdmin.config do |c|
      c.compact_show_view = false
    end

    visit show_path(:model_name => "team", :id => team.id)
  end

  describe "JSON show view" do
    before do
      @player = FactoryGirl.create :player
       visit uri
    end

    let(:uri) { show_path(:model_name => 'player', :id => @player.id, :format => :json) }
    let(:body) { page.body }

    it "creates a JSON uri" do
      expect(uri).to eq("/admin/player/#{@player.id}.json")
    end

    it "contains the JSONified object" do
      expect(body).to include(@player.to_json)
    end
  end

  describe "compact_show_view" do

    it "hides empty fields in show view by default" do
      @player = FactoryGirl.create :player
      visit show_path(:model_name => "league", :id => @player.id)
      should_not have_css(".born_on_field")
    end


    it "is disactivable" do
      RailsAdmin.config do |c|
        c.compact_show_view = false
      end

      @player = FactoryGirl.create :player
      visit show_path(:model_name => "player", :id => @player.id)
      should have_css(".born_on_field")
    end
  end

  describe "css hooks" do
    it "is present" do
      do_request

      should have_selector("dt .name_field.string_type")
    end
  end

  describe "field groupings" do
    it "is hideable" do
      RailsAdmin.config Team do
        show do
          group :default do
            hide
          end
        end
      end

      do_request

      should_not have_selector("h4", :text => "Basic info")

      %w[division name logo_url manager
        ballpark mascot founded wins
        losses win_percentage revenue
      ].each do |field|
        should_not have_selector(".#{field}_field")
      end
    end

    it "hides association groupings by the name of the association" do
      RailsAdmin.config Team do
        show do
          group :players do
            hide
          end
        end
      end

      do_request

      should_not have_selector("h4", :text => "Players")
    end

    it "is renameable" do
      RailsAdmin.config Team do
        show do
          group :default do
            label "Renamed group"
          end
        end
      end

      do_request

      should have_selector("h4", :text => "Renamed group")
    end

    it "has accessor for its fields" do
      RailsAdmin.config Team do
        show do
          group :default do
            field :name
            field :logo_url
          end
          group :belongs_to_associations do
            label "Belong's to associations"
            field :division
          end
        end
      end

      do_request

      should have_selector("h4", :text => "Basic info")
      should have_selector("h4", :text => "Belong's to associations")

      should have_selector(".name_field")
      should have_selector(".logo_url_field")
      should have_selector(".division_field")
    end

    it "has accessor for its fields by type" do
      RailsAdmin.config Team do
        show do
          group :default do
            field :name
            field :logo_url
          end
          group :other do
            field :division
            field :manager
            field :ballpark
            fields_of_type :string do
              label { "#{label} (STRING)" }
            end
          end
        end
      end

      do_request

      should have_selector(".label", :text => "Name")
      should have_selector(".label", :text => "Logo url")
      should have_selector(".label", :text => "Division")
      should have_selector(".label", :text => "Manager (STRING)")
      should have_selector(".label", :text => "Ballpark (STRING)")
    end
  end

  describe "items' fields" do

    it "shows all by default" do
      do_request

      %w[division name logo_url manager
        ballpark mascot founded wins
        losses win_percentage revenue players fans
      ].each do |field|
        should have_selector(".#{field}_field")
      end
    end

    it "only shows the defined fields and appear in order defined" do
      RailsAdmin.config Team do
        show do
          field :manager
          field :division
          field :name
        end
      end

      do_request

      should have_selector(".manager_field")
      should have_selector(".division_field")
      should have_selector(".name_field")
    end


    it "delegates the label option to the ActiveModel API" do
      RailsAdmin.config Team do
        show do
          field :manager
          field :fans
        end
      end

      do_request

      should have_selector(".label", :text => "Team Manager")
      should have_selector(".label", :text => "Some Fans")
    end

    it "is renameable" do
      RailsAdmin.config Team do
        show do
          field :manager do
            label "Renamed field"
          end
          field :division
          field :name
        end
      end

      do_request

      should have_selector(".label", :text => "Renamed field")
      should have_selector(".label", :text => "Division")
      should have_selector(".label", :text => "Name")
    end

    it "is renameable by type" do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            label { "#{label} (STRING)" }
          end
        end
      end

      do_request

      ["Division", "Name (STRING)", "Logo url (STRING)", "Manager (STRING)",
        "Ballpark (STRING)", "Mascot (STRING)", "Founded", "Wins", "Losses",
        "Win percentage", "Revenue", "Players", "Fans"
      ].each do |text|
        should have_selector(".label", :text => text)
      end
    end

    it "is globally renameable by type" do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            label { "#{label} (STRING)" }
          end
        end
      end

      do_request

      ["Division", "Name (STRING)", "Logo url (STRING)", "Manager (STRING)",
        "Ballpark (STRING)", "Mascot (STRING)", "Founded", "Wins", "Losses",
        "Win percentage", "Revenue", "Players", "Fans"
      ].each do |text|
        should have_selector(".label", :text => text)
      end
    end

    it "is hideable" do
      RailsAdmin.config Team do
        show do
          field :manager do
            hide
          end
          field :division
          field :name
        end
      end

      do_request

      should have_selector(".division_field")
      should have_selector(".name_field")
    end

    it "is hideable by type" do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            hide
          end
        end
      end

      do_request

      %w[Name Logo\ url Manager Ballpark Mascot].each do |text|
        should_not have_selector(".label", :text => text)
      end

      %w[Division Founded Wins Losses Win\ percentage Revenue Players Fans].each do |text|
        should have_selector(".label", :text => text)
      end
    end

    it "is globally hideable by type" do
      RailsAdmin.config Team do
        show do
          fields_of_type :string do
            hide
          end
        end
      end

      do_request

      %w[Name Logo\ url Manager Ballpark Mascot].each do |text|
        should_not have_selector(".label", :text => text)
      end

      %w[Division Founded Wins Losses Win\ percentage Revenue Players Fans].each do |text|
        should have_selector(".label", :text => text)
      end
    end
  end

  describe "embedded model", :mongoid => true do
    it "does not show link to individual object's page" do
      @record = FactoryGirl.create :field_test
      2.times.each{|i| @record.embeds.create :name => "embed #{i}"}
      visit show_path(:model_name => "field_test", :id => @record.id)
      should_not have_link('embed 0')
      should_not have_link('embed 1')
    end
  end
end
