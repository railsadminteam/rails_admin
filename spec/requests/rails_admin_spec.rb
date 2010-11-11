require 'spec_helper'

describe "RailsAdmin" do
  include Warden::Test::Helpers

  before(:each) do
    RailsAdmin::AbstractModel.new("Division").destroy_all!
    RailsAdmin::AbstractModel.new("Draft").destroy_all!
    RailsAdmin::AbstractModel.new("Fan").destroy_all!
    RailsAdmin::AbstractModel.new("League").destroy_all!
    RailsAdmin::AbstractModel.new("Player").destroy_all!
    RailsAdmin::AbstractModel.new("Team").destroy_all!
    RailsAdmin::AbstractModel.new("User").destroy_all!

    user = RailsAdmin::AbstractModel.new("User").create(
      :email => "test@test.com",
      :password => "test1234"
    )

    login_as user
  end

  after(:each) do
    Warden.test_reset!
  end

  describe "history blank results" do
    before(:each) do
      @months = RailsAdmin::History.add_blank_results([RailsAdmin::BlankHistory.new(3, 2011)], 10, 2010)
    end

    it "should pad the correct number of months" do
      @months.length.should == 5
    end

    it "should pad at the beginning" do
      @months.first.fake.should == 1
      @months.map(&:month).should == [11, 12, 1, 2, 3]
    end

    it "should handle year-to-year rollover" do
      @months.map(&:year).should == [2010, 2010, 2011, 2011, 2011]
    end
  end

  describe "history ajax update" do
    it "shouldn't use the application layout" do
      post rails_admin_history_list_path, :ref => 0, :section => 4
      response.should_not have_tag "h1#app_layout_warning"
    end
  end

  describe "authentication" do
    it "should be disableable" do
      logout
      RailsAdmin.authenticate_with {}
      get rails_admin_dashboard_path
      response.should be_successful
    end
  end

  describe "config" do

    after(:each) do
      RailsAdmin::Config.reset
    end

    describe "excluded models" do
      excluded_models = [Division, Draft, Fan]

      before(:each) do
        RailsAdmin::Config.excluded_models = excluded_models
      end

      after(:each) do
        RailsAdmin::Config.excluded_models = []
      end

      it "should be hidden from navigation" do
        # Make query in team's edit view to make sure loading
        # the related division model config will not mess the navigation
        get rails_admin_new_path(:model_name => "team")
        excluded_models.each do |model|
          response.should have_tag("#nav") do |navigation|
            navigation.should_not have_tag("li a", :content => model.to_s)
          end
        end
      end

      it "should raise NotFound for the list view" do
        get rails_admin_list_path(:model_name => "fan")
        response.status.should equal(404)
      end

      it "should raise NotFound for the create view" do
        get rails_admin_new_path(:model_name => "fan")
        response.status.should equal(404)
      end

      it "should be hidden from other models relations in the edit view" do
        get rails_admin_new_path(:model_name => "team")
        response.should_not have_tag("#team_division_id")
        response.should_not have_tag("input#team_fans")
      end
    end

    describe "navigation" do

      describe "number of visible tabs" do
        after(:each) do
          RailsAdmin::Config::Sections::Navigation.max_visible_tabs = 5
        end

        it "should be editable" do
          RailsAdmin::Config::Sections::Navigation.max_visible_tabs = 2
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
            hide_in_navigation
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

    describe "list" do

      describe "number of items per page" do

        before(:each) do
          RailsAdmin::AbstractModel.new("League").create(:name => 'American')
          RailsAdmin::AbstractModel.new("League").create(:name => 'National')
          RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher", :retired => true, :injured => true)
          RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman", :retired => true, :injured => false)
        end

        it "should be configurable" do
          RailsAdmin::Config.model do
            list do
              items_per_page 1
            end
          end
          get rails_admin_list_path(:model_name => "league")
          response.should have_tag("#contentMainModules > .infoRow") do |elements|
            elements.should have_at_most(1).items
          end
          get rails_admin_list_path(:model_name => "player")
          response.should have_tag("#contentMainModules > .infoRow") do |elements|
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
          response.should have_tag("#contentMainModules > .infoRow") do |elements|
            elements.should have_at_most(1).items
          end
          get rails_admin_list_path(:model_name => "player")
          response.should have_tag("#contentMainModules > .infoRow") do |elements|
            elements.should have_at_most(2).items
          end
        end

        it "should be globally configurable and overrideable per model" do
          RailsAdmin::Config.model do
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
          response.should have_tag("#contentMainModules > .infoRow") do |elements|
            elements.should have_at_most(1).items
          end
          get rails_admin_list_path(:model_name => "player")
          response.should have_tag("#contentMainModules > .infoRow") do |elements|
            elements.should have_at_most(2).items
          end
        end
      end

      describe "items' fields" do

        it "should show all by default" do
          get rails_admin_list_path(:model_name => "fan")
          response.should have_tag("#moduleHeader > li") do |elements|
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
          response.should have_tag("#moduleHeader > li") do |elements|
            elements[1].should contain("UPDATED AT")
            elements[2].should contain("NAME")
            elements[3].should contain("ID")
            elements[4].should contain("CREATED AT")
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
          response.should have_tag("#moduleHeader > li") do |elements|
            elements.should contain("ID")
            elements.should contain("NAME")
            elements.should_not contain("CREATED AT")
            elements.should_not contain("UPDATED AT")
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
          response.should have_tag("#moduleHeader > li") do |elements|
            elements[1].should contain("IDENTIFIER")
            elements[2].should contain("NAME")
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
          response.should have_tag("#moduleHeader > li") do |elements|
            elements[1].should contain("ID")
            elements[2].should contain("CREATED AT (DATETIME)")
            elements[3].should contain("UPDATED AT (DATETIME)")
            elements[4].should contain("NAME")
          end
        end

        it "should be globally renameable by type" do
          RailsAdmin::Config.model do
            list do
              fields_of_type :datetime do
                label { "#{label} (DATETIME)" }
              end
            end
          end
          get rails_admin_list_path(:model_name => "fan")
          response.should have_tag("#moduleHeader > li") do |elements|
            elements[1].should contain("ID")
            elements[2].should contain("CREATED AT (DATETIME)")
            elements[3].should contain("UPDATED AT (DATETIME)")
            elements[4].should contain("NAME")
          end
        end

        it "should be sortable by default" do
          get rails_admin_list_path(:model_name => "fan")
          response.should have_tag("#moduleHeader > li") do |elements|
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
          response.should have_tag("#moduleHeader > li") do |elements|
            elements[1].should_not have_tag("a")
            elements[2].should have_tag("a")
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
          response.should have_tag("#moduleHeader > li") do |elements|
            elements[1].should have_tag("a")
            elements[2].should have_tag("a")
            elements[3].should_not have_tag("a")
            elements[4].should_not have_tag("a")
          end
        end

        it "should have option to disable sortability by type globally" do
          RailsAdmin::Config.model do
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
          response.should have_tag("#moduleHeader > li") do |elements|
            elements[1].should have_tag("a")
            elements[2].should have_tag("a")
            elements[3].should_not have_tag("a")
            elements[4].should_not have_tag("a")
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
          response.should have_tag("#moduleHeader > li") do |elements|
            elements.should contain("ID")
            elements.should contain("NAME")
            elements.should_not contain("CREATED AT")
            elements.should_not contain("UPDATED AT")
          end
        end

        it "should have option to hide fields by type globally" do
          RailsAdmin::Config.model do
            list do
              fields_of_type :datetime do
                hide
              end
            end
          end
          get rails_admin_list_path(:model_name => "fan")
          response.should have_tag("#moduleHeader > li") do |elements|
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
                column_css_class "customClass"
              end
              field :name
            end
          end

          RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
          RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

          get rails_admin_list_path(:model_name => "fan")

          response.should have_tag("#moduleHeader > li:nth-child(2).customClassHeader")
          response.should have_tag("#moduleHeader > li:nth-child(3).smallStringHeader")
          response.should have_tag(".infoRow") do |elements|
            elements[0].should have_tag("li:nth-child(2).customClassRow")
            elements[0].should have_tag("li:nth-child(3).smallStringRow")
          end
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

          response.should have_tag("#moduleHeader > li:nth-child(3).customClassHeader")
          response.should have_tag("#moduleHeader > li:nth-child(4).customClassHeader")
          response.should have_tag("#moduleHeader > li:nth-child(5).smallStringHeader")
          response.should have_tag(".infoRow") do |elements|
            elements[0].should have_tag("li:nth-child(3).customClassRow")
            elements[0].should have_tag("li:nth-child(4).customClassRow")
            elements[0].should have_tag("li:nth-child(5).smallStringRow")
          end
        end

        it "should have option to customize css class name by type globally" do
          RailsAdmin::Config.model do
            list do
              fields_of_type :datetime do
                column_css_class "customClass"
              end
            end
          end

          RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
          RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

          get rails_admin_list_path(:model_name => "fan")

          response.should have_tag("#moduleHeader > li:nth-child(3).customClassHeader")
          response.should have_tag("#moduleHeader > li:nth-child(4).customClassHeader")
          response.should have_tag("#moduleHeader > li:nth-child(5).smallStringHeader")
          response.should have_tag(".infoRow") do |elements|
            elements[0].should have_tag("li:nth-child(3).customClassRow")
            elements[0].should have_tag("li:nth-child(4).customClassRow")
            elements[0].should have_tag("li:nth-child(5).smallStringRow")
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

          RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
          RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

          get rails_admin_list_path(:model_name => "fan")

          response.should have_tag("style") {|css| css.should contain(/\.idHeader[^{]*\{[^a-z]*width:[^\d]*2\d{2}px;[^{]*\}/) }
          response.should have_tag("style") {|css| css.should contain(/\.idRow[^{]*\{[^a-z]*width:[^\d]*2\d{2}px;[^{]*\}/) }
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
            elements[0].should have_tag("li:nth-child(3)") {|li| li.should contain("FAN II") }
            elements[1].should have_tag("li:nth-child(3)") {|li| li.should contain("FAN I") }
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

          RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan I')
          RailsAdmin::AbstractModel.new("Fan").create(:name => 'Fan II')

          get rails_admin_list_path(:model_name => "fan")

          response.should have_tag(".infoRow") do |elements|
            elements[0].should have_tag("li:nth-child(4)") do |li|
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

          team = RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team I", :manager => "Manager I", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)

          RailsAdmin::AbstractModel.new("Player").create(:name => 'Player I', :number => 1, :team => team)
          RailsAdmin::AbstractModel.new("Player").create(:name => 'Player II', :number => 2, :team => team)
          RailsAdmin::AbstractModel.new("Player").create(:name => 'Player III', :number => 3, :team => team)

          get rails_admin_list_path(:model_name => "team")

          response.should have_tag(".infoRow") do |elements|
            elements[0].should have_tag("li:nth-child(4)") {|li| li.should contain("Player I, Player II, Player III") }
          end
        end
      end
    end

    describe "edit" do

      describe "field groupings" do

        it "should be hideable" do
          RailsAdmin.config Team do
            edit do
              group :default do
                label "Hidden group"
                hide
              end
            end
          end
          get rails_admin_new_path(:model_name => "team")
          # Should not have the group header
          response.should_not have_tag("h2", :content => "Hidden Group")
          # Should not have any of the group's fields either
          response.should_not have_tag("select#team_league_id")
          response.should_not have_tag("select#team_division_id")
          response.should_not have_tag("input#team_name")
          response.should_not have_tag("input#team_logo_url")
          response.should_not have_tag("input#team_manager")
          response.should_not have_tag("input#team_ballpark")
          response.should_not have_tag("input#team_mascot")
          response.should_not have_tag("input#team_founded")
          response.should_not have_tag("input#team_wins")
          response.should_not have_tag("input#team_losses")
          response.should_not have_tag("input#team_win_percentage")
          response.should_not have_tag("input#team_revenue")
        end

        it "should be renameable" do
          RailsAdmin.config Team do
            edit do
              group :default do
                label "Renamed group"
              end
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag("h2", :content => "Renamed group")
        end

      end

      describe "items' fields" do

        it "should show all by default" do
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag("select#team_league_id")
          response.should have_tag("select#team_division_id")
          response.should have_tag("input#team_name")
          response.should have_tag("input#team_logo_url")
          response.should have_tag("input#team_manager")
          response.should have_tag("input#team_ballpark")
          response.should have_tag("input#team_mascot")
          response.should have_tag("input#team_founded")
          response.should have_tag("input#team_wins")
          response.should have_tag("input#team_losses")
          response.should have_tag("input#team_win_percentage")
          response.should have_tag("input#team_revenue")
          response.should have_tag("input#team_players")
          response.should have_tag("input#team_fans")
        end

        it "should appear in order defined" do
          RailsAdmin.config Team do
            edit do
              field :manager
              field :division_id
              field :name
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements[0].should have_tag("#team_manager")
            elements[1].should have_tag("#team_division_id")
            elements[2].should have_tag("#team_name")
          end
        end

        it "should only show the defined fields if some fields are defined" do
          RailsAdmin.config Team do
            edit do
              field :league_id
              field :division_id
              field :name
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements[0].should have_tag("#team_league_id")
            elements[1].should have_tag("#team_division_id")
            elements[2].should have_tag("#team_name")
            elements.length.should == 3
          end
        end

        it "should be renameable" do
          RailsAdmin.config Team do
            edit do
              field :manager do
                label "Renamed field"
              end
              field :division_id
              field :name
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements[0].should have_tag("label", :content => "Renamed field")
            elements[1].should have_tag("label", :content => "Division")
            elements[2].should have_tag("label", :content => "Name")
          end
        end

        it "should be renameable by type" do
          RailsAdmin.config Team do
            edit do
              fields_of_type :string do
                label { "#{label} (STRING)" }
              end
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements.should have_tag("label", :content => "League")
            elements.should have_tag("label", :content => "Division")
            elements.should have_tag("label", :content => "Name (STRING)")
            elements.should have_tag("label", :content => "Logo url (STRING)")
            elements.should have_tag("label", :content => "Manager (STRING)")
            elements.should have_tag("label", :content => "Ballpark (STRING)")
            elements.should have_tag("label", :content => "Mascot (STRING)")
            elements.should have_tag("label", :content => "Founded")
            elements.should have_tag("label", :content => "Wins")
            elements.should have_tag("label", :content => "Losses")
            elements.should have_tag("label", :content => "Win percentage")
            elements.should have_tag("label", :content => "Revenue")
            elements.should have_tag("label", :content => "Players")
            elements.should have_tag("label", :content => "Fans")
          end
        end

        it "should be globally renameable by type" do
          RailsAdmin::Config.model do
            edit do
              fields_of_type :string do
                label { "#{label} (STRING)" }
              end
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements.should have_tag("label", :content => "League")
            elements.should have_tag("label", :content => "Division")
            elements.should have_tag("label", :content => "Name (STRING)")
            elements.should have_tag("label", :content => "Logo url (STRING)")
            elements.should have_tag("label", :content => "Manager (STRING)")
            elements.should have_tag("label", :content => "Ballpark (STRING)")
            elements.should have_tag("label", :content => "Mascot (STRING)")
            elements.should have_tag("label", :content => "Founded")
            elements.should have_tag("label", :content => "Wins")
            elements.should have_tag("label", :content => "Losses")
            elements.should have_tag("label", :content => "Win percentage")
            elements.should have_tag("label", :content => "Revenue")
            elements.should have_tag("label", :content => "Players")
            elements.should have_tag("label", :content => "Fans")
          end
        end

        it "should be hideable" do
          RailsAdmin.config Team do
            edit do
              field :manager do
                hide
              end
              field :division_id
              field :name
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements[0].should have_tag("#team_division_id")
            elements[1].should have_tag("#team_name")
          end
        end

        it "should be hideable by type" do
          RailsAdmin.config Team do
            edit do
              fields_of_type :string do
                hide
              end
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements.should have_tag("label", :content => "League")
            elements.should have_tag("label", :content => "Division")
            elements.should_not have_tag("label", :content => "Name")
            elements.should_not have_tag("label", :content => "Logo url")
            elements.should_not have_tag("label", :content => "Manager")
            elements.should_not have_tag("label", :content => "Ballpark")
            elements.should_not have_tag("label", :content => "Mascot")
            elements.should have_tag("label", :content => "Founded")
            elements.should have_tag("label", :content => "Wins")
            elements.should have_tag("label", :content => "Losses")
            elements.should have_tag("label", :content => "Win percentage")
            elements.should have_tag("label", :content => "Revenue")
            elements.should have_tag("label", :content => "Players")
            elements.should have_tag("label", :content => "Fans")
          end
        end

        it "should be globally hideable by type" do
          RailsAdmin::Config.model do
            edit do
              fields_of_type :string do
                hide
              end
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements.should have_tag("label", :content => "League")
            elements.should have_tag("label", :content => "Division")
            elements.should_not have_tag("label", :content => "Name")
            elements.should_not have_tag("label", :content => "Logo url")
            elements.should_not have_tag("label", :content => "Manager")
            elements.should_not have_tag("label", :content => "Ballpark")
            elements.should_not have_tag("label", :content => "Mascot")
            elements.should have_tag("label", :content => "Founded")
            elements.should have_tag("label", :content => "Wins")
            elements.should have_tag("label", :content => "Losses")
            elements.should have_tag("label", :content => "Win percentage")
            elements.should have_tag("label", :content => "Revenue")
            elements.should have_tag("label", :content => "Players")
            elements.should have_tag("label", :content => "Fans")
          end
        end

        it "should have option to customize the help text" do
          RailsAdmin.config Team do
            edit do
              field :manager do
                help "#{help} Additional help text for manager field."
              end
              field :division_id
              field :name
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements[0].should have_tag("p.help", :content => "Required 100 characters or fewer. Additional help text for manager field.")
            elements[1].should have_tag("p.help", :content => "Required")
            elements[2].should have_tag("p.help", :content => "Optional 50 characters or fewer.")
          end
        end

        it "should have option to override required status" do
          RailsAdmin.config Team do
            edit do
              field :manager do
                optional true
              end
              field :division_id do
                optional true
              end
              field :name do
                required true
              end
            end
          end
          get rails_admin_new_path(:model_name => "team")
          response.should have_tag(".field") do |elements|
            elements[0].should have_tag("p.help", :content => "Optional 100 characters or fewer.")
            elements[1].should have_tag("p.help", :content => "Optional")
            elements[2].should have_tag("p.help", :content => "Required 50 characters or fewer.")
          end
        end

      end

      describe "fields which are nullable and have AR validations" do
        it "should be required" do
          # draft.notes is nullable and has no validation
          field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :notes}
          field.properties[:nullable?].should be true
          field.required?.should be false

          # draft.date is nullable in the schema but has an AR
          # validates_presence_of validation that makes it required
          field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :date}
          field.properties[:nullable?].should be true
          field.required?.should be true

          # draft.round is nullable in the schema but has an AR
          # validates_numericality_of validation that makes it required
          field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :round}
          field.properties[:nullable?].should be true
          field.required?.should be true

          # team.revenue is nullable in the schema but has an AR
          # validates_numericality_of validation that allows nil
          field = RailsAdmin::config("Team").edit.fields.find{|f| f.name == :revenue}
          field.properties[:nullable?].should be true
          field.required?.should be false
        end
      end

    end
  end

  describe "GET /admin" do
    before(:each) do
      get rails_admin_dashboard_path
    end

    it "should respond sucessfully" do
      response.code.should == "200"
    end

  end

  describe "GET /admin/player as list" do
    before(:each) do
      get rails_admin_list_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"Select model to edit\"" do
      response.body.should contain("Select player to edit")
    end

    it "should show filters" do
      response.body.should contain(/CREATED AT\n\s*UPDATED AT\n\s*/)
    end

    it "should show column headers" do
      response.body.should contain(/EDIT\n\s*DELETE\n\s*/)
    end
  end

  describe "GET /admin/player with sort" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      get rails_admin_list_path(:model_name => "player", :sort => "name", :set => 1)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should be sorted correctly" do
      response.body.should contain(/Sandy Koufax/)
      response.body.should contain(/Jackie Robinson/)
    end
  end

  describe "GET /admin/player with reverse sort" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      get rails_admin_list_path(:model_name => "player", :sort => "name", :sort_reverse => "true", :set => 1)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should be sorted correctly" do
      response.body.should contain(/Sandy Koufax/)
      response.body.should contain(/Jackie Robinson/)
    end
  end

  describe "GET /admin/player with query" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher")
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman")
      get rails_admin_list_path(:model_name => "player", :query => "Jackie Robinson", :set => 1)
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show a correct result" do
      @response.body.should contain("Jackie Robinson")
    end

    it "should not contain an incorrect result" do
      @response.body.should_not contain("Sandy Koufax")
    end
  end

  describe "GET /admin/player with query and boolean filter" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher", :retired => true, :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman", :retired => true, :injured => false)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 18, :name => "Moises Alou", :position => "Left fielder", :retired => false, :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 5, :name => "David Wright", :position => "Third baseman", :retired => false, :injured => false)
      get rails_admin_list_path(:model_name => "player", :query => "Sandy Koufax", :filter => {:injured => "true"}, :set => 1)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show a correct result" do
      response.body.should contain("Sandy Koufax")
    end

    it "should not contain an incorrect result" do
      response.body.should_not contain("Jackie Robinson")
      response.body.should_not contain("Moises Alou")
      response.body.should_not contain("David Wright")
    end
  end

  describe "GET /admin/player with boolean filter" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 18, :name => "Moises Alou", :position => "Left fielder", :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 5, :name => "David Wright", :position => "Third baseman", :injured => false)
      get rails_admin_list_path(:model_name => "player", :filter => {:injured => "true"}, :set => 1)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show a correct result" do
      response.body.should contain("Moises Alou")
    end

    it "should not contain an incorrect result" do
      response.body.should_not contain("David Wright")
    end
  end

  describe "GET /admin/player with boolean filters" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 32, :name => "Sandy Koufax", :position => "Starting patcher", :retired => true, :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 42, :name => "Jackie Robinson", :position => "Second baseman", :retired => true, :injured => false)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 18, :name => "Moises Alou", :position => "Left fielder", :retired => false, :injured => true)
      RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 5, :name => "David Wright", :position => "Third baseman", :retired => false, :injured => false)
      get rails_admin_list_path(:model_name => "player", :filter => {:retired => "true", :injured => "true"}, :set => 1)
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show a correct result" do
    end

    it "should not contain an incorrect result" do
      @response.body.should_not contain("Jackie Robinson")
      @response.body.should_not contain("Moises Alou")
      @response.body.should_not contain("David Wright")
    end
  end

  describe "GET /admin/player with 2 objects" do
    before(:each) do

      (1..2).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"2 results\"" do
      response.body.should contain("2 players")
    end
  end

  describe "GET /admin/player with 20 objects" do
    before(:each) do

      (1..20).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end

    it "should show \"20 results\"" do
      @response.body.should contain("20 players")
    end
  end

  describe "GET /admin/player with 20 objects, page 8" do
    before(:each) do
      per_page = 20
      page_numers = 20
      (1..per_page * page_numers).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player", :page => 8)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should paginate correctly" do
      response.body.should contain(/1 2 [^0-9]*5 6 7 8 9 10 11[^0-9]*19 20/)
    end
  end

  describe "list with 20 objects, page 17" do
    before(:each) do
      per_page = 20
      max_pages = 20
      (1..per_page * max_pages).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player", :page => 18)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should paginate correctly" do
      @response.body.should contain(/1 2[^0-9]*12 13 14 15 16 17 18 19 20/)
    end
  end

  describe "GET /admin/player show all" do
    before(:each) do
      (1..2).each do |number|
        RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => number, :name => "Player #{number}")
      end

      get rails_admin_list_path(:model_name => "player", :all => true)
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  #new

  describe "GET /admin/player/new" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"New model\"" do
      response.body.should contain("New player")
    end

    it "should show required fields as \"Required\"" do
      response.body.should contain(/Name\n\s*Required/)
      response.body.should contain(/Number\n\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      response.body.should contain(/Position\n\s*Optional/)
      response.body.should contain(/Born on\n\s*Optional/)
      response.body.should contain(/Notes\n\s*Optional/)
    end
  end

  describe "GET /admin/player/new with has-one association" do
    before(:each) do
      RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))
      get rails_admin_new_path(:model_name => "player")

    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Draft #\d+/)
    end
  end

  describe "GET /admin/player/new with has-many association" do
    before(:each) do
      (1..3).each do |number|
        RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Team 1Team 2Team 3/)
    end
  end

  pending "GET /admin/team/:id/fans/new with has-and-belongs-to-many association" do
    before(:each) do
      (1..3).each do |number|
        RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_new_path(:model_name => "team")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Team 1/)
    end
  end

  describe "GET /admin/player/new with missing label" do
    before(:each) do
      (1..3).each do |number|
        RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      get rails_admin_new_path(:model_name => "player")
    end

    it "should respond sucessfully" do
      response.should be_successful
    end
  end

  describe "create" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"

      @req = click_button "Save"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "create and edit" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")
      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      @req = click_button "Save and edit"

      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @response.should be_successful
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "create and add another" do
    before(:each) do
      get rails_admin_new_path(:model_name => "player")
      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"
      @req = click_button "Save and add another"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should create an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "create with has-one association" do
    before(:each) do
      @draft = RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))
      get rails_admin_new_path(:model_name => "player")
      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => 42
      fill_in "player[position]", :with => "Second baseman"
      select "Draft ##{@draft.id}"
      @req = click_button "Save"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should create an object with correct associations" do
      @draft.reload
      @player.draft.should eql(@draft)
    end
  end

  describe "create with has-many association" do
    before(:each) do
      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_new_path(:model_name => "league")

      fill_in "league[name]", :with => "National League"

      set_hidden_field "associations[teams][]", :to => @teams[0].id.to_s.to_i
      @req = click_button "Save"

      @league = RailsAdmin::AbstractModel.new("League").first
    end

    it "should create an object with correct associations" do
      @teams[0].reload
      @league.teams.should include(@teams[0])
    end

    it "should not create an object with incorrect associations" do
      @league.teams.should_not include(@teams[1])
      @league.teams.should_not include(@teams[2])
    end
  end

  pending "create with has-and-belongs-to-many association" do
    before(:each) do
      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_new_path(:model_name => "league")

      fill_in "league[name]", :with => "National League"

      set_hidden_field "associations[teams][]", :to => @teams[0].id.to_s.to_i
      @req = click_button "Save"

      @league = RailsAdmin::AbstractModel.new("League").first
    end

    it "should create an object with correct associations" do
      @teams[0].reload
      @league.teams.should include(@teams[0])
    end

    it "should not create an object with incorrect associations" do
      @league.teams.should_not include(@teams[1])
      @league.teams.should_not include(@teams[2])
    end
  end

  describe "create with uniqueness constraint violated", :given => "a player exists" do
    before(:each) do
      @team =  RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team 1", :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => @team.id, :number => 1, :name => "Player 1")

      get rails_admin_new_path(:model_name => "player")

      fill_in "player[name]", :with => @player.name
      fill_in "player[number]", :with => @player.number.to_s
      fill_in "player[position]", :with => @player.position
      select "#{@team.name}", :from => "player[team_id]"

      @req = click_button "Save"
    end

    it "should show an error message" do
      @req.body.should contain("There is already a player with that number on this team")
    end
  end

  describe "create with invalid object" do
    before(:each) do
        @response = visit(rails_admin_create_path(:model_name => "player"), :post, :params => {:player => {}})
    end

    it "should show an error message" do
      @response.body.should contain("Player failed to be created")
    end
  end

  describe "edit" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"Edit model\"" do
      response.body.should contain("Edit player")
    end

    it "should show required fields as \"Required\"" do
      response.body.should contain(/Name\n\s*Required/)
      response.body.should contain(/Number\n\s*Required/)
    end

    it "should show non-required fields as \"Optional\"" do
      response.body.should contain(/Position\n\s*Optional/)
      response.body.should contain(/Born on\n\s*Optional/)
      response.body.should contain(/Notes\n\s*Optional/)
    end
  end

  describe "edit with has-one association" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      @draft = RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))

      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Draft #\d+/)
    end
  end

  describe "edit with has-many association" do
    before(:each) do
      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Team 1Team 2Team 3/)
    end
  end

  pending "edit with has-and-belongs-to-many association" do
    before(:each) do
      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show associated objects" do
      response.body.should contain(/Team 1Team 2Team 3/)
    end
  end

  describe "edit with missing object" do
    before(:each) do
      get rails_admin_edit_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      response.status.should equal(404)
    end
  end

  describe "edit with missing label", :given => ["a player exists", "three teams with no name exist"] do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")

      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end
  end

  describe "update and add another" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"

      @req = click_button "Save"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "update and edit" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"

      @req = click_button "Save and edit"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end
  end

  describe "update with has-one association" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      @draft = RailsAdmin::AbstractModel.new("Draft").create(:player_id => rand(99999), :team_id => rand(99999), :date => Date.today, :round => rand(50), :pick => rand(30), :overall => rand(1500))

      get rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "42"
      fill_in "player[position]", :with => "Second baseman"

      select "Draft ##{@draft.id}"

      @req = click_button "Save"
      @player = RailsAdmin::AbstractModel.new("Player").first
      # @response = rails_admin_update, :model_name => "player", :id => @player.id), :put, :params => {:player => {:name => "Jackie Robinson", :number => 42, :team_id => 1, :position => "Second baseman"}, :associations => {:draft => @draft.id}})
    end

    it "should update an object with correct attributes" do
      @player.name.should eql("Jackie Robinson")
      @player.number.should eql(42)
      @player.position.should eql("Second baseman")
    end

    it "should update an object with correct associations" do
      @draft.reload
      @player.draft.should eql(@draft)
    end
  end

  describe "update with has-many association", :given => ["a league exists", "three teams exist"] do
    before(:each) do
      @league = RailsAdmin::AbstractModel.new("League").create(:name => "League 1")

      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_edit_path(:model_name => "league", :id => @league.id)

      fill_in "league[name]", :with => "National League"

      set_hidden_field "associations[teams][]", :to => @teams[0].id.to_s.to_i

      response = click_button "Save"
      @league = RailsAdmin::AbstractModel.new("League").first
    end

    it "should update an object with correct attributes" do
      @league.name.should eql("National League")
    end

    it "should update an object with correct associations" do
      @teams[0].reload
      @league.teams.should include(@teams[0])
    end

    it "should not update an object with incorrect associations" do
      @league.teams.should_not include(@teams[1])
      @league.teams.should_not include(@teams[2])
    end
  end

  pending "update with has-many association", :given => ["a league exists", "three teams exist"] do
    before(:each) do
      @league = RailsAdmin::AbstractModel.new("League").create(:name => "League 1")

      @teams = []
      (1..3).each do |number|
        @teams << RailsAdmin::AbstractModel.new("Team").create(:league_id => rand(99999), :division_id => rand(99999), :name => "Team #{number}", :manager => "Manager #{number}", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)
      end

      get rails_admin_edit_path(:model_name => "league", :id => @league.id)

      fill_in "league[name]", :with => "National League"

      set_hidden_field "associations[teams][]", :to => @teams[0].id.to_s.to_i

      response = click_button "Save"
      @league = RailsAdmin::AbstractModel.new("League").first
    end

    it "should update an object with correct attributes" do
      @league.name.should eql("National League")
    end

    it "should update an object with correct associations" do
      @teams[0].reload
      @league.teams.should include(@teams[0])
    end

    it "should not update an object with incorrect associations" do
      @league.teams.should_not include(@teams[1])
      @league.teams.should_not include(@teams[2])
    end
  end

  describe "update with missing object" do
    before(:each) do
      @response = visit(rails_admin_update_path(:model_name => "player", :id => 1), :put, {:player => {:name => "Jackie Robinson", :number => 42, :position => "Second baseman"}})
    end

    it "should raise NotFound" do
      @response.status.should equal(404)
    end
  end

  describe "update with invalid object" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)

      fill_in "player[name]", :with => "Jackie Robinson"
      fill_in "player[number]", :with => "a"
      fill_in "player[position]", :with => "Second baseman"
      @req = click_button "Save"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should show an error message" do
      @req.body.should contain("Player failed to be updated")
    end
  end

  describe "delete" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")
      get rails_admin_delete_path(:model_name => "player", :id => @player.id)
    end

    it "should respond sucessfully" do
      response.should be_successful
    end

    it "should show \"Delete model\"" do
      response.body.should contain("Delete player")
    end
  end

  describe "delete with missing object" do
    before(:each) do
      get rails_admin_delete_path(:model_name => "player", :id => 1)
    end

    it "should raise NotFound" do
      @response.status.should equal(404)
    end
  end

  describe "delete with missing label" do
    before(:each) do
      @league = RailsAdmin::AbstractModel.new("League").create(:name => "League 1")
      @team = RailsAdmin::AbstractModel.new("Team").create(:league_id => @league.id, :division_id => rand(99999), :manager => "Manager 1", :founded => 1869 + rand(130), :wins => (wins = rand(163)), :losses => 162 - wins, :win_percentage => ("%.3f" % (wins.to_f / 162)).to_f)

      get rails_admin_delete_path(:model_name => "league", :id => @league.id)
    end

    it "should respond sucessfully" do
      @response.should be_successful
    end
  end

  describe "destroy" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")

      get rails_admin_delete_path(:model_name => "player", :id => @player.id)

      @req = click_button "Yes, I'm sure"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should destroy an object" do
      @player.should be_nil
    end
  end

  describe "destroy" do
    before(:each) do
      @player = RailsAdmin::AbstractModel.new("Player").create(:team_id => rand(99999), :number => 1, :name => "Player 1")

      get rails_admin_delete_path(:model_name => "player", :id => @player.id)

      @req = click_button "Cancel"
      @player = RailsAdmin::AbstractModel.new("Player").first
    end

    it "should be successful" do
      @req.should be_successful
    end

    it "should destroy an object" do
      @player.should_not be_nil
    end
  end

  describe "destroy with missing object" do
    before(:each) do
      @req = visit(rails_admin_destroy_path(:model_name => "player", :id => 1), :delete)
    end

    it "should raise NotFound" do
      @req.status.should equal(404)
    end
  end

end
