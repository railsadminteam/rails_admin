require 'spec_helper'

describe "RailsAdmin Config DSL Edit Section" do

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

      # Reset
      RailsAdmin::Config.reset Team
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

      # Reset
      RailsAdmin::Config.reset Team
    end

    it "should have accessor for its fields" do
      RailsAdmin.config Team do
        edit do
          group :default do
            field :name
            field :logo_url
          end
          group :belongs_to_associations do
            label "Belong's to associations"
            field :league_id
            field :division_id
          end
        end
      end
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag("h2", :content => "Basic info")
      response.should have_tag("h2", :content => "Belong's to associations")
      response.should have_tag(".field") do |elements|
        elements[0].should have_tag("#teams_name")
        elements[1].should have_tag("#teams_logo_url")
        elements[2].should have_tag("#teams_league_id")
        elements[3].should have_tag("#teams_division_id")
        elements.length.should == 4
      end

      # Reset
      RailsAdmin::Config.reset Team
    end

    it "should have accessor for its fields by type" do
      RailsAdmin.config Team do
        edit do
          group :default do
            field :league_id
            field :name
            field :logo_url
          end
          group :other do
            field :division_id
            field :manager
            field :ballpark
            fields_of_type :string do
              label { "#{label} (STRING)" }
            end
          end
        end
      end
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag(".field") do |elements|
        elements.should have_tag("label", :content => "League")
        elements.should have_tag("label", :content => "Name")
        elements.should have_tag("label", :content => "Logo url")
        elements.should have_tag("label", :content => "Division")
        elements.should have_tag("label", :content => "Manager (STRING)")
        elements.should have_tag("label", :content => "Ballpark (STRING)")
      end

      # Reset
      RailsAdmin::Config.reset Team
    end
  end

  describe "items' fields" do

    it "should show all by default" do
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag("select#teams_league_id")
      response.should have_tag("select#teams_division_id")
      response.should have_tag("input#teams_name")
      response.should have_tag("input#teams_logo_url")
      response.should have_tag("input#teams_manager")
      response.should have_tag("input#teams_ballpark")
      response.should have_tag("input#teams_mascot")
      response.should have_tag("input#teams_founded")
      response.should have_tag("input#teams_wins")
      response.should have_tag("input#teams_losses")
      response.should have_tag("input#teams_win_percentage")
      response.should have_tag("input#teams_revenue")
      response.should have_tag("input#teams_players")
      response.should have_tag("input#teams_fans")
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
        elements[0].should have_tag("#teams_manager")
        elements[1].should have_tag("#teams_division_id")
        elements[2].should have_tag("#teams_name")
      end

      # Reset
      RailsAdmin::Config.reset Team
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
        elements[0].should have_tag("#teams_league_id")
        elements[1].should have_tag("#teams_division_id")
        elements[2].should have_tag("#teams_name")
        elements.length.should == 3
      end

      # Reset
      RailsAdmin::Config.reset Team
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

      # Reset
      RailsAdmin::Config.reset Team
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

      # Reset
      RailsAdmin::Config.reset Team
    end

    it "should be globally renameable by type" do
      RailsAdmin::Config.models do
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

      # Reset
      RailsAdmin::Config.reset
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
        elements[0].should have_tag("#teams_division_id")
        elements[1].should have_tag("#teams_name")
      end

      # Reset
      RailsAdmin::Config.reset Team
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

      # Reset
      RailsAdmin::Config.reset Team
    end

    it "should be globally hideable by type" do
      RailsAdmin::Config.models do
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

      # Reset
      RailsAdmin::Config.reset
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

      # Reset
      RailsAdmin::Config.reset Team
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

      # Reset
      RailsAdmin::Config.reset Team
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

  describe "CKEditor Support" do
    it "should start with CKEditor disabled" do
       field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :notes}
       field.ckeditor.should be false
    end

    it "should add Javascript to enable CKEditor" do
      RailsAdmin.config Draft do
        edit do
          field :notes do
            ckeditor true
          end
        end
      end

      get rails_admin_new_path(:model_name => "draft")
      response.should contain(/CKEDITOR\.replace.*?drafts_notes/)
    end
  end

  describe "Paperclip Support" do

    it "should show a file upload field" do
      RailsAdmin.config User do
        edit do
          field :avatar
        end
      end
      get rails_admin_new_path(:model_name => "user")
      response.should have_tag("input#users_avatar")
    end

  end
end
