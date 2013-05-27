# coding: utf-8

require 'spec_helper'

describe "RailsAdmin Config DSL Edit Section" do

  subject { page }

  describe " a field with 'format' as a name (Kernel function)" do

    it "is updatable without any error" do
      RailsAdmin.config FieldTest do
        edit do
          field :format
        end
      end
      visit new_path(:model_name => "field_test")
      fill_in "field_test[format]", :with => "test for format"
      click_button "Save" # first(:button, "Save").click
      @record = RailsAdmin::AbstractModel.new("FieldTest").first
      expect(@record.format).to eq("test for format")
    end
  end

  describe "default_value" do

    it "is set for all types of input fields" do
      RailsAdmin.config do |config|
        config.excluded_models = []
        config.model(FieldTest) do

          field :string_field do
            default_value 'string_field default_value'
          end
          field :text_field do
            default_value 'string_field text_field'
          end
          field :boolean_field do
            default_value true
          end
          field :date_field do
            default_value Date.today
          end
        end
      end

      visit new_path(:model_name => "field_test")
      # In Rails 3.2.3 behavior of textarea has changed to insert newline after the opening tag,
      # but Capybara's RackTest driver is not up to this behavior change.
      # (https://github.com/jnicklas/capybara/issues/677)
      # So we manually cut off first newline character as a workaround here.
      expect(find_field('field_test[string_field]').value.gsub(/^\n/, '')).to eq('string_field default_value')
      expect(find_field('field_test[text_field]').value.gsub(/^\n/, '')).to eq('string_field text_field')
      expect(find_field('field_test[date_field]').value).to eq(Date.today.to_s)
      expect(has_checked_field?('field_test[boolean_field]')).to be_true
    end

    it "sets default value for selects" do
      RailsAdmin.config(Team) do
        field :color, :enum do
          default_value 'black'
          enum do
            ['black', 'white']
          end
        end
      end
      visit new_path(:model_name => "team")
      expect(find_field('team[color]').value).to eq('black')
    end
  end

  describe "attr_accessible" do


    it "is configurable in the controller scope" do

      RailsAdmin.config do |config|
        config.excluded_models = []
        config.attr_accessible_role do
          _current_user.attr_accessible_role # sould be :custom_role
        end

        config.model FieldTest do
          edit do
            field :string_field
            field :restricted_field
            field :protected_field
          end
        end
      end

      visit new_path(:model_name => "field_test")
      fill_in "field_test[string_field]", :with => "No problem here"
      fill_in "field_test[restricted_field]", :with => "I'm allowed to do that as :custom_role only"
      should have_no_selector "field_test[protected_field]"
      click_button "Save" # first(:button, "Save").click
      @field_test = FieldTest.first
      expect(@field_test.string_field).to eq("No problem here")
      expect(@field_test.restricted_field).to eq("I'm allowed to do that as :custom_role only")
    end
  end

  describe "css hooks" do
    it "is present" do
      visit new_path(:model_name => "team")
      should have_selector("#team_division_id_field.belongs_to_association_type.division_field")
    end
  end

  describe "field groupings" do

    it "is hideable" do
      RailsAdmin.config Team do
        edit do
          group :default do
            label "Hidden group"
            hide
          end
        end
      end
      visit new_path(:model_name => "team")
      # Should not have the group header
      should have_no_selector("legend", :text => "Hidden Group")
      # Should not have any of the group's fields either
      should have_no_selector("select#team_division")
      should have_no_selector("input#team_name")
      should have_no_selector("input#team_logo_url")
      should have_no_selector("input#team_manager")
      should have_no_selector("input#team_ballpark")
      should have_no_selector("input#team_mascot")
      should have_no_selector("input#team_founded")
      should have_no_selector("input#team_wins")
      should have_no_selector("input#team_losses")
      should have_no_selector("input#team_win_percentage")
      should have_no_selector("input#team_revenue")
    end

    it "hides association groupings" do
      RailsAdmin.config Team do
        edit do
          group :players do
            label "Players"
            field :players
            hide
          end
        end
      end
      visit new_path(:model_name => "team")
      # Should not have the group header
      should have_no_selector("legend", :text => "Players")
      # Should not have any of the group's fields either
      should have_no_selector("select#team_player_ids")
    end

    it "is renameable" do
      RailsAdmin.config Team do
        edit do
          group :default do
            label "Renamed group"
          end
        end
      end
      visit new_path(:model_name => "team")
      # NOTE: capybara 2.0 is exceedingly reluctant to reveal the text of invisible elements. This was
      # the least terrible option I was able to find. It would probably be better to refactor the test
      # so the label we're looking for is displayed.
      expect(find("legend", :visible => false).native.text).to include("Renamed group")
    end

    describe "help" do
      before(:each) do
        class HelpTest < Tableless
          column :name, 'string(50)'
          column :division, :string
        end
        RailsAdmin.config.included_models = [HelpTest, Team]
      end

      after(:each) do
        # restore validation setting
        HelpTest._validators[:name] = []
        HelpTest.reset_callbacks(:validate)
      end

      context "using mongoid", :skip_active_record => true do
        it "uses the db column size for the maximum length" do
          visit new_path(:model_name => "help_test")
          expect(find("#help_test_name_field .help-block")).to have_content("Length up to 255.")
        end

        it "returns nil for the maximum length" do
          visit new_path(:model_name => "team")
          expect(find("#team_custom_field_field .help-block")).not_to have_content("Length")
        end
      end

      context "using active_record", :skip_mongoid => true do
        it "uses the db column size for the maximum length" do
          visit new_path(:model_name => "help_test")
          expect(find("#help_test_name_field .help-block")).to have_content("Length up to 50.")
        end

        it "uses the :minimum setting from the validation" do
          HelpTest.class_eval do
            validates_length_of :name, :minimum => 1
          end
          visit new_path(:model_name => "help_test")
          expect(find("#help_test_name_field .help-block")).to have_content("Length of 1-50.")
        end

        it "uses the minimum of db column size or :maximum setting from the validation" do
          HelpTest.class_eval do
            validates_length_of :name, :maximum => 51
          end
          visit new_path(:model_name => "help_test")
          expect(find("#help_test_name_field .help-block")).to have_content("Length up to 50.")
        end
      end

      it "shows help section if present" do
        RailsAdmin.config HelpTest do
          edit do
            group :default do
              help "help paragraph to display"
            end
          end
        end
        visit new_path(:model_name => "help_test")
        should have_selector('fieldset>p', :text => "help paragraph to display")
      end

      it "does not show help if not present" do
        RailsAdmin.config HelpTest do
          edit do
            group :default do
              label 'no help'
            end
          end
        end
        visit new_path(:model_name => "help_test")
        should_not have_selector('fieldset>p')
      end

      it "is able to display multiple help if there are multiple sections" do
        RailsAdmin.config HelpTest do
          edit do
            group :default do
              field :name
              help 'help for default'
            end
            group :other_section do
              label "Other Section"
              field :division
              help 'help for other section'
            end
          end
        end
        visit new_path(:model_name => "help_test")
        should have_selector("fieldset>p", :text => 'help for default')
        should have_selector("fieldset>p", :text => 'help for other section')
        should have_selector("fieldset>p", :count => 2)
      end

      it "uses the :is setting from the validation" do
        HelpTest.class_eval do
          validates_length_of :name, :is => 3
        end
        visit new_path(:model_name => "help_test")
        expect(find("#help_test_name_field .help-block")).to have_content("Length of 3.")
      end

      it "uses the :maximum setting from the validation" do
        HelpTest.class_eval do
          validates_length_of :name, :maximum => 49
        end
        visit new_path(:model_name => "help_test")
        expect(find("#help_test_name_field .help-block")).to have_content("Length up to 49.")
      end

      it "uses the :minimum and :maximum from the validation" do
        HelpTest.class_eval do
          validates_length_of :name, :minimum => 1, :maximum => 49
        end
        visit new_path(:model_name => "help_test")
        expect(find("#help_test_name_field .help-block")).to have_content("Length of 1-49.")
      end

      it "uses the range from the validation" do
        HelpTest.class_eval do
          validates_length_of :name, :in => 1..49
        end
        visit new_path(:model_name => "help_test")
        expect(find("#help_test_name_field .help-block")).to have_content("Length of 1-49.")
      end

    end

    it "has accessor for its fields" do
      RailsAdmin.config Team do
        edit do
          group :default do
            field :name
            field :logo_url
          end
          group :belongs_to_associations do
            label "Belong's to associations"
            field :division
          end
          group :basic_info do
            field :manager
          end
        end
      end
      visit new_path(:model_name => "team")
      should have_selector("legend", :text => "Basic info", :visible => false)
      should have_selector("legend", :text => "Basic info", :visible => true)
      should have_selector("legend", :text => "Belong's to associations")
      should have_selector("label", :text => "Name")
      should have_selector("label", :text => "Logo url")
      should have_selector("label", :text => "Division")
      should have_selector(".control-group", :count => 4)
    end

    it "has accessor for its fields by type" do
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
      visit new_path(:model_name => "team")
      should have_selector("label", :text => "Name")
      should have_selector("label", :text => "Logo url")
      should have_selector("label", :text => "Division")
      should have_selector("label", :text => "Manager (STRING)")
      should have_selector("label", :text => "Ballpark (STRING)")
    end
  end

  describe "items' fields" do

    it "shows all by default" do
      visit new_path(:model_name => "team")
      should have_selector("select#team_division_id")
      should have_selector("input#team_name")
      should have_selector("input#team_logo_url")
      should have_selector("input#team_manager")
      should have_selector("input#team_ballpark")
      should have_selector("input#team_mascot")
      should have_selector("input#team_founded")
      should have_selector("input#team_wins")
      should have_selector("input#team_losses")
      should have_selector("input#team_win_percentage")
      should have_selector("input#team_revenue")
      should have_selector("select#team_player_ids")
      should have_selector("select#team_fan_ids")
    end

    it "appears in order defined" do
      RailsAdmin.config Team do
        edit do
          field :manager
          field :division
          field :name
        end
      end
      visit new_path(:model_name => "team")
      should have_selector(:xpath, "//*[contains(@class, 'field')][1]//*[@id='team_manager']")
      should have_selector(:xpath, "//*[contains(@class, 'field')][2]//*[@id='team_division_id']")
      should have_selector(:xpath, "//*[contains(@class, 'field')][3]//*[@id='team_name']")
    end

    it "only shows the defined fields if some fields are defined" do
      RailsAdmin.config Team do
        edit do
          field :division
          field :name
        end
      end
      visit new_path(:model_name => "team")
      should have_selector("label", :text => "Division")
      should have_selector("label", :text => "Name")
      should have_selector(".control-group", :count => 2)
    end

    describe "I18n awarly" do
      after :each do
        I18n.locale = :en
      end

      it "delegates the label option to the ActiveModel API and memoizes it" do
        RailsAdmin.config Team do
          edit do
            field :manager
            field :fans
          end
        end
        visit new_path(:model_name => "team")
        should have_selector("label", :text => "Team Manager")
        should have_selector("label", :text => "Some Fans")
        I18n.locale = :fr
        visit new_path(:model_name => "team")
        should have_selector("label", :text => "Manager de l'équipe")
        should have_selector("label", :text => "Quelques fans")
      end
    end

    it "is renameable" do
      RailsAdmin.config Team do
        edit do
          field :manager do
            label "Renamed field"
          end
          field :division
          field :name
        end
      end
      visit new_path(:model_name => "team")
      should have_selector("label", :text => "Renamed field")
      should have_selector("label", :text => "Division")
      should have_selector("label", :text => "Name")
    end

    it "is renameable by type" do
      RailsAdmin.config Team do
        edit do
          fields_of_type :string do
            label { "#{label} (STRING)" }
          end
        end
      end
      visit new_path(:model_name => "team")
      should have_selector("label", :text => "Division")
      should have_selector("label", :text => "Name (STRING)")
      should have_selector("label", :text => "Logo url (STRING)")
      should have_selector("label", :text => "Manager (STRING)")
      should have_selector("label", :text => "Ballpark (STRING)")
      should have_selector("label", :text => "Mascot (STRING)")
      should have_selector("label", :text => "Founded")
      should have_selector("label", :text => "Wins")
      should have_selector("label", :text => "Losses")
      should have_selector("label", :text => "Win percentage")
      should have_selector("label", :text => "Revenue")
      should have_selector("label", :text => "Players")
      should have_selector("label", :text => "Fans")
    end

    it "is globally renameable by type" do
      RailsAdmin.config Team do
        edit do
          fields_of_type :string do
            label { "#{label} (STRING)" }
          end
        end
      end
      visit new_path(:model_name => "team")
      should have_selector("label", :text => "Division")
      should have_selector("label", :text => "Name (STRING)")
      should have_selector("label", :text => "Logo url (STRING)")
      should have_selector("label", :text => "Manager (STRING)")
      should have_selector("label", :text => "Ballpark (STRING)")
      should have_selector("label", :text => "Mascot (STRING)")
      should have_selector("label", :text => "Founded")
      should have_selector("label", :text => "Wins")
      should have_selector("label", :text => "Losses")
      should have_selector("label", :text => "Win percentage")
      should have_selector("label", :text => "Revenue")
      should have_selector("label", :text => "Players")
      should have_selector("label", :text => "Fans")
    end

    it "is flaggable as read only and be configurable with formatted_value" do
      RailsAdmin.config Team do
        edit do
          field :name do
            read_only true
            formatted_value do
              "I'm outputed in the form"
            end
          end
        end
      end
      visit new_path(:model_name => "team")
      should have_content("I'm outputed in the form")
    end

    it "is hideable" do
      RailsAdmin.config Team do
        edit do
          field :manager do
            hide
          end
          field :division
          field :name
        end
      end
      visit new_path(:model_name => "team")
      should have_no_selector("#team_manager")
      should have_selector("#team_division_id")
      should have_selector("#team_name")
    end

    it "is hideable by type" do
      RailsAdmin.config Team do
        edit do
          fields_of_type :string do
            hide
          end
        end
      end
      visit new_path(:model_name => "team")
      should have_selector("label", :text => "Division")
      should have_no_selector("label", :text => "Name")
      should have_no_selector("label", :text => "Logo url")
      should have_no_selector("label", :text => "Manager")
      should have_no_selector("label", :text => "Ballpark")
      should have_no_selector("label", :text => "Mascot")
      should have_selector("label", :text => "Founded")
      should have_selector("label", :text => "Wins")
      should have_selector("label", :text => "Losses")
      should have_selector("label", :text => "Win percentage")
      should have_selector("label", :text => "Revenue")
      should have_selector("label", :text => "Players")
      should have_selector("label", :text => "Fans")
    end

    it "is globally hideable by type" do
      RailsAdmin.config Team do
        edit do
          fields_of_type :string do
            hide
          end
        end
      end
      visit new_path(:model_name => "team")
      should have_selector("label", :text => "Division")
      should have_no_selector("label", :text => "Name")
      should have_no_selector("label", :text => "Logo url")
      should have_no_selector("label", :text => "Manager")
      should have_no_selector("label", :text => "Ballpark")
      should have_no_selector("label", :text => "Mascot")
      should have_selector("label", :text => "Founded")
      should have_selector("label", :text => "Wins")
      should have_selector("label", :text => "Losses")
      should have_selector("label", :text => "Win percentage")
      should have_selector("label", :text => "Revenue")
      should have_selector("label", :text => "Players")
      should have_selector("label", :text => "Fans")
    end

    it "has option to customize the help text" do
      RailsAdmin.config Team do
        edit do
          field :manager do
            help "#{help} Additional help text for manager field."
          end
          field :division
          field :name
        end
      end
      visit new_path(:model_name => "team")
      expect(find("#team_manager_field .help-block")).to have_content("Required. Length up to 100. Additional help text for manager field.")
      expect(find("#team_division_id_field .help-block")).to have_content("Required")
      expect(find("#team_name_field .help-block")).not_to have_content("Additional help text")
    end

    it "has option to override required status" do
      RailsAdmin.config Team do
        edit do
          field :manager do
            optional true
          end
          field :division do
            optional true
          end
          field :name do
            required true
          end
        end
      end
      visit new_path(:model_name => "team")
      expect(find("#team_manager_field .help-block")).to have_content("Optional")
      expect(find("#team_division_id_field .help-block")).to have_content("Optional")
      expect(find("#team_name_field .help-block")).to have_content("Required")
    end

    it "can hide the add button on an associated field" do
      RailsAdmin.config Player do
        edit do
          field :team do
            inline_add false
          end
          field :draft do
            inline_add false
          end
          field :comments do
            inline_add false
          end
        end
      end
      visit new_path(:model_name => "player")
      should have_no_selector('a', :text => 'Add a new Team')
      should have_no_selector('a', :text => 'Add a new Draft')
      should have_no_selector('a', :text => 'Add a new Comment')
    end

    it "can show the add button on an associated field" do
      RailsAdmin.config Player do
        edit do
          field :team do
            inline_add true
          end
          field :draft do
            inline_add true
          end
          field :comments do
            inline_add true
          end
        end
      end
      visit new_path(:model_name => "player")
      should have_selector('a', :text => 'Add a new Team')
      should have_selector('a', :text => 'Add a new Draft')
      should have_selector('a', :text => 'Add a new Comment')
    end

    it "can hide the edit button on an associated field" do
      RailsAdmin.config Player do
        edit do
          field :team do
            inline_edit false
          end
          field :draft do
            inline_edit false
          end
        end
      end
      visit new_path(:model_name => "player")
      should have_no_selector('a', :text => 'Edit this Team')
      should have_no_selector('a', :text => 'Edit this Draft')
    end

    it "can show the edit button on an associated field" do
      RailsAdmin.config Player do
        edit do
          field :team do
            inline_edit true
          end
          field :draft do
            inline_edit true
          end
        end
      end
      visit new_path(:model_name => "player")
      should have_selector('a', :text => 'Edit this Team')
      should have_selector('a', :text => 'Edit this Draft')
    end

  end

  describe "bindings" do
    it "is present at creation time" do
      RailsAdmin.config do |config|
        config.excluded_models = []
      end
      RailsAdmin.config Category do
        field :parent_category do
          visible do
            !bindings[:object].new_record?
          end
        end
      end

      visit new_path(:model_name => 'category')
      should have_no_css('#category_parent_category_id')
      click_button "Save" # first(:button, "Save").click
      visit edit_path(:model_name => 'category', :id => Category.first)
      should have_css('#category_parent_category_id')
      click_button "Save" # first(:button, "Save").click
      should have_content('Category successfully updated')
    end
  end

  describe "nested form" do
    it "works" do
      @record = FactoryGirl.create :field_test
      @record.nested_field_tests = [NestedFieldTest.create!(:title => 'title 1'), NestedFieldTest.create!(:title => 'title 2')]
      visit edit_path(:model_name => "field_test", :id => @record.id)
      fill_in "field_test_comment_attributes_content", :with => 'nested comment content'
      fill_in "field_test_nested_field_tests_attributes_0_title", :with => 'nested field test title 1 edited'
      page.find('#field_test_nested_field_tests_attributes_1__destroy').set('true')
      click_button "Save" # first(:button, "Save").click
      @record.reload
      expect(@record.comment.content).to eq('nested comment content')
      expect(@record.nested_field_tests.length).to eq(1)
      expect(@record.nested_field_tests[0].title).to eq('nested field test title 1 edited')
    end

    it "sets bindings[:object] to nested object" do
      RailsAdmin.config(NestedFieldTest) do
        nested do
          field :title do
            label do
              bindings[:object].class.name
            end
          end
        end
      end
      @record = FieldTest.create
      @record.nested_field_tests << NestedFieldTest.create!(:title => 'title 1')
      visit edit_path(:model_name => "field_test", :id => @record.id)
      expect(find('#field_test_nested_field_tests_attributes_0_title_field')).to have_content('NestedFieldTest')
    end

    it "is desactivable" do
      visit new_path(:model_name => "field_test")
      should have_selector('#field_test_nested_field_tests_attributes_field .add_nested_fields')
      RailsAdmin.config(FieldTest) do
        configure :nested_field_tests do
          nested_form false
        end
      end
      visit new_path(:model_name => "field_test")
      should have_no_selector('#field_test_nested_field_tests_attributes_field .add_nested_fields')
    end

    describe "with nested_attributes_options given" do
      before do
        FieldTest.nested_attributes_options.stub(:[]).with(any_args()).
          and_return({:allow_destroy=>true, :update_only=>false})
      end

      it "does not show add button when :update_only is true" do
        FieldTest.nested_attributes_options.stub(:[]).with(:nested_field_tests).
          and_return({:allow_destroy=>true, :update_only=>true})
        visit new_path(:model_name => "field_test")
        should have_selector('.toggler')
        should_not have_selector('#field_test_nested_field_tests_attributes_field .add_nested_fields')
      end

      it "does not show destroy button except for newly created when :allow_destroy is false" do
        @record = FieldTest.create
        @record.nested_field_tests << NestedFieldTest.create!(:title => 'nested title 1')
        FieldTest.nested_attributes_options.stub(:[]).with(:nested_field_tests).
          and_return({:allow_destroy=>false, :update_only=>false})
        visit edit_path(:model_name => "field_test", :id => @record.id)
        expect(find('#field_test_nested_field_tests_attributes_0_title').value).to eq('nested title 1')
        should_not have_selector('form .remove_nested_fields')
        expect(find('div#nested_field_tests_fields_blueprint')[:'data-blueprint']).to match(
          /<a[^>]* class="remove_nested_fields"[^>]*>/)
      end
    end

    describe "when a field which have the same name of nested_in field's" do
      it "does not hide fields which are not associated with nesting parent field's model" do
        visit new_path(:model_name => "field_test")
        should_not have_selector('select#field_test_nested_field_tests_attributes_new_nested_field_tests_field_test_id')
        expect(find('div#nested_field_tests_fields_blueprint')[:'data-blueprint']).to match(
          /<select[^>]* id="field_test_nested_field_tests_attributes_new_nested_field_tests_another_field_test_id"[^>]*>/)
      end
    end
  end

  describe "embedded model", :mongoid => true do
    it "works" do
      @record = FactoryGirl.create :field_test
      2.times.each{|i| @record.embeds.create :name => "embed #{i}"}
      visit edit_path(:model_name => "field_test", :id => @record.id)
      fill_in "field_test_embeds_attributes_0_name", :with => 'embed 1 edited'
      page.find('#field_test_embeds_attributes_1__destroy').set('true')
      click_button "Save" # first(:button, "Save").click
      @record.reload
      expect(@record.embeds.length).to eq(1)
      expect(@record.embeds[0].name).to eq('embed 1 edited')
    end
  end


  describe "fields which are nullable and have AR validations", :active_record => true do

    it "is required" do
      # draft.notes is nullable and has no validation
      field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :notes}
      expect(field.properties[:nullable?]).to be_true
      expect(field.required?).to be_false

      # draft.date is nullable in the schema but has an AR
      # validates_presence_of validation that makes it required
      field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :date}
      expect(field.properties[:nullable?]).to be_true
      expect(field.required?).to be_true

      # draft.round is nullable in the schema but has an AR
      # validates_numericality_of validation that makes it required
      field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :round}
      expect(field.properties[:nullable?]).to be_true
      expect(field.required?).to be_true

      # team.revenue is nullable in the schema but has an AR
      # validates_numericality_of validation that allows nil
      field = RailsAdmin::config("Team").edit.fields.find{|f| f.name == :revenue}
      expect(field.properties[:nullable?]).to be_true
      expect(field.required?).to be_false
    end
  end

  describe "CKEditor Support" do

    it "starts with CKEditor disabled" do
       field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :notes}
       expect(field.ckeditor).to be_false
    end

    it "adds Javascript to enable CKEditor" do
      RailsAdmin.config Draft do
        edit do
          field :notes do
            ckeditor true
          end
        end
      end
      visit new_path(:model_name => "draft")
      should have_selector('textarea#draft_notes[data-richtext="ckeditor"]')
    end
  end

  describe "CodeMirror Support" do

    it "starts with CodeMirror disabled" do
       field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :notes}
       expect(field.codemirror).to be_false
    end

    it "adds Javascript to enable CodeMirror" do
      RailsAdmin.config Draft do
        edit do
          field :notes do
            codemirror true
          end
        end
      end
      visit new_path(:model_name => "draft")
      should have_selector('textarea#draft_notes[data-richtext="codemirror"]')
    end
  end

  describe "bootstrap_wysihtml5 Support" do

    it "starts with bootstrap_wysihtml5 disabled" do
       field = RailsAdmin::config("Draft").edit.fields.find{|f| f.name == :notes}
       expect(field.bootstrap_wysihtml5).to be_false
    end

    it "adds Javascript to enable bootstrap_wysihtml5" do
      RailsAdmin.config Draft do
        edit do
          field :notes do
            bootstrap_wysihtml5 true
          end
        end
      end
      visit new_path(:model_name => "draft")
      should have_selector('textarea#draft_notes[data-richtext="bootstrap-wysihtml5"]')
    end

    it "should include custom wysihtml5 configuration" do
      RailsAdmin.config Draft do
        edit do
          field :notes do
            bootstrap_wysihtml5 true
            bootstrap_wysihtml5_config_options :image => false
            bootstrap_wysihtml5_css_location 'stub_css.css'
            bootstrap_wysihtml5_js_location 'stub_js.js'
          end
        end
      end

      visit new_path(:model_name => "draft")
      should have_selector("textarea#draft_notes[data-richtext=\"bootstrap-wysihtml5\"][data-options]")
    end
  end

  describe "Paperclip Support" do

    it "shows a file upload field" do
      RailsAdmin.config User do
        edit do
          field :avatar
        end
      end
      visit new_path(:model_name => "user")
      should have_selector("input#user_avatar")
    end
  end

  describe "Enum field support" do
    describe "when object responds to '\#{method}_enum'" do
      before do
        Team.class_eval do
          def color_enum
            ["blue", "green", "red"]
          end
        end
        RailsAdmin.config Team do
          edit do
            field :color
          end
        end
        visit new_path(:model_name => "team")
      end

      after do
        Team.send(:remove_method, :color_enum)
      end

      it "auto-detects enumeration" do
        should have_selector(".enum_type select")
        should_not have_selector(".enum_type select[multiple]")
        should have_content("green")
      end
    end

    describe "when class responds to '\#{method}_enum'" do
      before do
        Team.instance_eval do
          def color_enum
            ["blue", "green", "red"]
          end
        end
        RailsAdmin.config Team do
          edit do
            field :color
          end
        end
        visit new_path(:model_name => "team")
      end

      after do
        Team.instance_eval { undef :color_enum }
      end

      it "auto-detects enumeration" do
        should have_selector(".enum_type select")
        should have_content("green")
      end
    end

    describe "the enum instance method" do
      before do
        Team.class_eval do
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
        visit new_path(:model_name => "team")
      end

      after do
        Team.send(:remove_method, :color_list)
      end

      it "allows configuration" do
        should have_selector(".enum_type select")
        should have_content("green")
      end
    end

    describe "the enum class method" do
      before do
        Team.instance_eval do
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
        visit new_path(:model_name => "team")
      end

      after do
        Team.instance_eval { undef :color_list }
      end

      it "allows configuration" do
        should have_selector(".enum_type select")
        should have_content("green")
      end
    end

    describe "when overriding enum configuration" do
      before do
        Team.class_eval do
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
        visit new_path(:model_name => "team")
      end

      after do
        Team.send(:remove_method, :color_list)
      end

      it "allows direct listing of enumeration options and override enum method" do
        should have_selector(".enum_type select")
        should have_no_content("green")
        should have_content("yellow")
      end
    end

    describe "when serialize is enabled in ActiveRecord model", :active_record => true do
      before do
        Team.instance_eval do
          serialize :color
          def color_enum
            ["blue", "green", "red"]
          end
        end
        visit new_path(:model_name => "team")
      end

      after do
        Team.serialized_attributes.clear
        Team.instance_eval { undef :color_enum }
      end

      it "makes enumeration multi-selectable" do
        should have_selector(".enum_type select[multiple]")
      end
    end

    describe "when serialize is enabled in Mongoid model", :mongoid => true do
      before do
        Team.instance_eval do
          field :color, :type => Array
          def color_enum
            ["blue", "green", "red"]
          end
        end
        visit new_path(:model_name => "team")
      end

      after do
        Team.instance_eval do
          field :color, :type => String
          undef :color_enum
        end
      end

      it "makes enumeration multi-selectable" do
        should have_selector(".enum_type select[multiple]")
      end
    end
  end

  describe "ColorPicker Support" do
    it "shows input with class color" do
      RailsAdmin.config Team do
        edit do
          field :color, :color
        end
      end
      visit new_path(:model_name => "team")
      should have_selector(".color_type input")
    end
  end

end
