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
      response.should_not have_tag("legend", :content => "Hidden Group")
      # Should not have any of the group's fields either
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

    it "should hide association groupings by the name of the association" do
      RailsAdmin.config Team do
        edit do
          group :players do
            hide
          end
        end
      end
      get rails_admin_new_path(:model_name => "team")
      # Should not have the group header
      response.should_not have_tag("legend", :content => "Players")
      # Should not have any of the group's fields either
      response.should_not have_tag("select#team_player_ids")
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

      response.should have_tag("legend", :content => "Renamed group")
    end
    
    describe "help" do
    
      it "should show help section if present" do
        RailsAdmin.config Team do
          edit do
            group :default do
              help "help paragraph to display"
            end
          end
        end
        get rails_admin_new_path(:model_name => "team")
      
        response.should have_tag('div.help', :content => "help paragraph to display")    
      end
    
      it "should not show help if not present" do
        RailsAdmin.config Team do
          edit do
            group :default do
              label 'no help'
            end
          end
        end
        get rails_admin_new_path(:model_name => "team")
      
        response.should_not have_tag('div.help')    
      end
      
      it "should be able to display multiple help if there are multiple sections" do
        RailsAdmin.config Team do
          edit do
            group :default do
              field :name
              help 'help for default'           
            end
            group :other_section do
              label "Other Section"
              field :division_id
              help 'help for other section'                         
            end
          end
        end
        get rails_admin_new_path(:model_name => "team")
        response.should have_tag("div.help", :content => 'help for default')
        response.should have_tag("div.help", :content => 'help for other section')        
        response.should have_tag("div.help", :count => 2)
      end  
      
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
            field :division_id
          end
        end
      end
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag("legend", :content => "Basic info")
      response.should have_tag("legend", :content => "Belong's to associations")
      response.should have_tag(".field") do |elements|
        elements[0].should have_tag("#team_name")
        elements[1].should have_tag("#team_logo_url")
        elements[2].should have_tag("#team_division_id")
        elements.length.should == 3
      end
    end

    it "should have accessor for its fields by type" do
      RailsAdmin.config Team do
        edit do
          group :default do
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
        elements.should have_tag("label", :content => "Name")
        elements.should have_tag("label", :content => "Logo url")
        elements.should have_tag("label", :content => "Division")
        elements.should have_tag("label", :content => "Manager (STRING)")
        elements.should have_tag("label", :content => "Ballpark (STRING)")
      end
    end
  end

  describe "items' fields" do

    it "should show all by default" do
      get rails_admin_new_path(:model_name => "team")
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
      response.should have_tag("select#team_player_ids")
      response.should have_tag("select#team_fan_ids")
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
          field :division_id
          field :name
        end
      end
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag(".field") do |elements|
        elements[0].should have_tag("#team_division_id")
        elements[1].should have_tag("#team_name")
        elements.length.should == 2
      end
    end

    it "should delegates the label option to the ActiveModel API" do
      RailsAdmin.config Team do
        edit do
          field :manager
          field :fans
        end
      end

      get rails_admin_new_path(:model_name => "team")
      response.should have_tag(".field") do |elements|
        elements[0].should have_tag("label", :content => "Team Manager")
        elements[1].should have_tag("label", :content => "Some Fans")
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
      RailsAdmin::Config.models do
        edit do
          fields_of_type :string do
            label { "#{label} (STRING)" }
          end
        end
      end
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag(".field") do |elements|
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
      RailsAdmin::Config.models do
        edit do
          fields_of_type :string do
            hide
          end
        end
      end
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag(".field") do |elements|
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

  describe "input format of" do

    before(:each) do
      RailsAdmin::Config.excluded_models = [RelTest]
      @time = ::Time.now.getutc
    end

    describe "a datetime field" do
      
      it "should default to %B %d, %Y %H:%M" do
        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[datetime_field]", :with => @time.strftime("%B %d, %Y %H:%M")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.datetime_field.strftime("%Y-%m-%d %H:%M").should eql(@time.strftime("%Y-%m-%d %H:%M"))
      end

      it "should have a simple customization option" do
        RailsAdmin.config FieldTest do
          edit do
            field :datetime_field do
              date_format :default
            end
          end
        end

        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[datetime_field]", :with => @time.strftime("%a, %d %b %Y %H:%M:%S")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.datetime_field.should eql(::DateTime.parse(@time.to_s))
      end

      it "should have a customization option" do
        RailsAdmin.config FieldTest do
          list do
            field :datetime_field do
              strftime_format "%Y-%m-%d %H:%M:%S"
            end
          end
        end

        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[datetime_field]", :with => @time.strftime("%Y-%m-%d %H:%M:%S")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.datetime_field.should eql(::DateTime.parse(@time.to_s))
      end
    end

    describe "a timestamp field" do

      it "should default to %B %d, %Y %H:%M" do
        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[timestamp_field]", :with => @time.strftime("%B %d, %Y %H:%M")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.timestamp_field.strftime("%Y-%m-%d %H:%M").should eql(@time.strftime("%Y-%m-%d %H:%M"))
      end

      it "should have a simple customization option" do
        RailsAdmin.config FieldTest do
          edit do
            field :timestamp_field do
              date_format :default
            end
          end
        end

        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[timestamp_field]", :with => @time.strftime("%a, %d %b %Y %H:%M:%S")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.timestamp_field.should eql(::DateTime.parse(@time.to_s))
      end

      it "should have a customization option" do
        RailsAdmin.config FieldTest do
          edit do
            field :timestamp_field do
              strftime_format "%Y-%m-%d %H:%M:%S"
            end
          end
        end

        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[timestamp_field]", :with => @time.strftime("%Y-%m-%d %H:%M:%S")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.timestamp_field.should eql(::DateTime.parse(@time.to_s))
      end
    end
    
    describe " a field with 'format' as a name (Kernel function)" do
      it "should be updatable without any error" do
      
        RailsAdmin.config FieldTest do
          edit do
            field :format
          end
        end

        get rails_admin_new_path(:model_name => "field_test")
        
        fill_in "field_test[format]", :with => "test for format"
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.format.should eql("test for format")
      end
    end


    describe "a time field" do

      it "should default to %H:%M" do
        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[time_field]", :with => @time.strftime("%H:%M")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.time_field.strftime("%H:%M").should eql(@time.strftime("%H:%M"))
      end

      it "should have a customization option" do
        RailsAdmin.config FieldTest do
          edit do
            field :time_field do
              strftime_format "%I:%M %p"
            end
          end
        end

        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[time_field]", :with => @time.strftime("%I:%M %p")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.time_field.strftime("%H:%M").should eql(@time.strftime("%H:%M"))
      end
    end

    describe "a date field" do

      it "should default to %B %d, %Y" do
        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[date_field]", :with => @time.strftime("%B %d, %Y")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.date_field.should eql(::Date.parse(@time.to_s))
      end


      it "should have a simple customization option" do
        RailsAdmin.config FieldTest do
          edit do
            field :date_field do
              date_format :default
            end
          end
        end

        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[date_field]", :with => @time.strftime("%Y-%m-%d")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.date_field.should eql(::Date.parse(@time.to_s))
      end

      it "should have a customization option" do
        RailsAdmin.config FieldTest do
          edit do
            field :date_field do
              strftime_format "%Y-%m-%d"
            end
          end
        end

        get rails_admin_new_path(:model_name => "field_test")

        fill_in "field_test[date_field]", :with => @time.strftime("%Y-%m-%d")
        click_button "Save"

        @record = RailsAdmin::AbstractModel.new("FieldTest").first

        @record.date_field.should eql(::Date.parse(@time.to_s))
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
      response.should contain(/CKEDITOR\.replace.*?draft_notes/)
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
      response.should have_tag("input#user_avatar")
    end

  end
  
  describe "Enum field support" do
    it "should auto-detect enumeration when object responds to '\#{method}_enum'" do
      class Team
        def color_enum
          ["blue", "green", "red"]
        end
      end
      
      RailsAdmin.config Team do
        edit do
          field :color
        end
      end
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag("select.enum")
      response.should contain("green")
      
      #Reset
      Team.send(:remove_method, :color_enum)  
      RailsAdmin::Config.reset Team
    end
    
    it "should allow configuration of the enum method" do
      class Team
        def color_list
          ["blue", "green", "red"]
        end
      end
      
      RailsAdmin.config Team do
        edit do
          field :color, :enum do
            enum_method :color_list
          end
        end
      end
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag("select.enum")
      response.should contain("green")
      
      #Reset
      Team.send(:remove_method, :color_list)
      RailsAdmin::Config.reset Team
    end
    
    it "should allow direct listing of enumeration options and override enum method" do
      class Team
        def color_list
          ["blue", "green", "red"]
        end
      end
      
      RailsAdmin.config Team do
        edit do
          field :color, :enum do
            enum_method :color_list
            enum do
              ["yellow", "black"]
            end
          end
        end
      end
      
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag("select.enum")
      response.should_not contain("green")
      response.should contain("yellow")
    
      #Reset
      Team.send(:remove_method, :color_list)
      RailsAdmin::Config.reset Team
    end

  end
  
  describe "ColorPicker Support" do
    it "should show input with class color" do
      RailsAdmin.config Team do
        edit do
          field :color do
            color true
          end
        end
      end
      get rails_admin_new_path(:model_name => "team")
      response.should have_tag("input.color")
    end
  end

  describe "Form builder configuration" do

    it "should allow override of default" do
      RailsAdmin.config do |config|
        config.model Player do
          edit do
            field :name
          end
        end
        config.model Team do
          edit do
            form_builder :form_for_edit
            field :name
          end
        end
        config.model Fan do
          create do
            form_builder :form_for_create
            field :name
          end
          update do
            form_builder :form_for_update
            field :name
          end
        end
        config.model League do
          create do
            form_builder :form_for_league_create
            field :name
          end
          update do
            field :name
          end
        end
      end

      RailsAdmin::Config.model(Player).create.form_builder.should be(:form_for)
      RailsAdmin::Config.model(Player).update.form_builder.should be(:form_for)
      RailsAdmin::Config.model(Player).edit.form_builder.should be(:form_for)

      RailsAdmin::Config.model(Team).update.form_builder.should be(:form_for_edit)
      RailsAdmin::Config.model(Team).create.form_builder.should be(:form_for_edit)
      RailsAdmin::Config.model(Team).edit.form_builder.should be(:form_for_edit)

      RailsAdmin::Config.model(Fan).create.form_builder.should be(:form_for_create)
      RailsAdmin::Config.model(Fan).update.form_builder.should be(:form_for_update)
      RailsAdmin::Config.model(Fan).edit.form_builder.should be(:form_for_update) # not sure we care

      RailsAdmin::Config.model(League).create.form_builder.should be(:form_for_league_create)
      RailsAdmin::Config.model(League).update.form_builder.should be(:form_for)
      RailsAdmin::Config.model(League).edit.form_builder.should be(:form_for) # not sure we care

      # don't spill over into other views
      expect {
        RailsAdmin::Config.model(Team).list.form_builder
      }.to raise_error(NoMethodError,/undefined method/)
    end

    it "should be used in the new and edit views" do
      TF_CREATE_OUTPUT = "MY TEST FORM CREATE TEXT FIELD"
      TF_UPDATE_OUTPUT = "MY TEST FORM UPDATE TEXT FIELD"

      module MyCreateForm
        class Builder < ::ActionView::Helpers::FormBuilder
          def text_field(*args)
            TF_CREATE_OUTPUT
          end
        end

        module ViewHelper
          def create_form_for(*args, &block)
            options = args.extract_options!.reverse_merge(:builder => MyCreateForm::Builder)
            form_for(*(args << options), &block)
          end
        end
      end

      module MyUpdateForm
        class Builder < ::ActionView::Helpers::FormBuilder
          def text_field(*args)
            TF_UPDATE_OUTPUT
          end
        end

        module ViewHelper
          def update_form_for(*args, &block)
            options = args.extract_options!.reverse_merge(:builder => MyUpdateForm::Builder)
            form_for(*(args << options), &block)
          end
        end
      end

      class ActionView::Base
        include MyCreateForm::ViewHelper
        include MyUpdateForm::ViewHelper
      end

      RailsAdmin.config do |config|
        config.model Player do
          edit do
            field :name
          end
        end
        config.model Team do
          edit do
            form_builder :create_form_for
            field :name
          end
        end
        config.model League do
          create do
            form_builder :create_form_for
            field :name
          end
          update do
            form_builder :update_form_for
            field :name
          end
        end
      end

      get rails_admin_new_path(:model_name => "player")
      response.should have_tag("input#player_name")
      response.should_not contain(TF_CREATE_OUTPUT)
      response.should_not contain(TF_UPDATE_OUTPUT)
      @player = FactoryGirl.create :player
      get rails_admin_edit_path(:model_name => "player", :id => @player.id)
      response.should have_tag("input#player_name")
      response.should_not contain(TF_CREATE_OUTPUT)
      response.should_not contain(TF_UPDATE_OUTPUT)

      get rails_admin_new_path(:model_name => "team")
      response.should contain(TF_CREATE_OUTPUT)
      response.should_not contain(TF_UPDATE_OUTPUT)
      @team = FactoryGirl.create :team
      get rails_admin_edit_path(:model_name => "team", :id => @team.id)
      response.should contain(TF_CREATE_OUTPUT)
      response.should_not contain(TF_UPDATE_OUTPUT)

      get rails_admin_new_path(:model_name => "league")
      response.should contain(TF_CREATE_OUTPUT)
      response.should_not contain(TF_UPDATE_OUTPUT)
      @league = FactoryGirl.create :league
      get rails_admin_edit_path(:model_name => "league", :id => @league.id)
      response.should_not contain(TF_CREATE_OUTPUT)
      response.should contain(TF_UPDATE_OUTPUT)
    end

  end

end
