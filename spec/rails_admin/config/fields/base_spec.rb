require 'spec_helper'

describe RailsAdmin::Config::Fields::Base do

  describe "#required" do
    it "reads the :on => :create/:update validate option" do
      RailsAdmin.config Ball do
        field 'color'
      end

      expect(RailsAdmin.config('Ball').fields.first.with(:object => Ball.new)).to be_required
      expect(RailsAdmin.config('Ball').fields.first.with(:object => FactoryGirl.create(:ball))).not_to be_required
    end

    context 'on a Paperclip installation' do
      it "should detect required fields" do
        expect(RailsAdmin.config('Image').fields.find{ |f| f.name == :file }.with(:object => Image.new)).to be_required
      end
    end
  end

  describe "#name" do
    it "is normalized to Symbol" do
      RailsAdmin.config Team do
        field 'name'
      end
      expect(RailsAdmin.config('Team').fields.first.name).to eq(:name)
    end
  end

  describe "#children_fields" do
    POLYMORPHIC_CHILDREN =
      if CI_ORM == :mongoid && Mongoid::VERSION >= '3.0.0'
        [:commentable_id, :commentable_type, :commentable_field]
      else
        [:commentable_id, :commentable_type]
      end

    it "is empty by default" do
      expect(RailsAdmin.config(Team).fields.find{ |f| f.name == :name }.children_fields).to eq([])
    end

    it "contains child key for belongs to associations" do
      expect(RailsAdmin.config(Team).fields.find{ |f| f.name == :division }.children_fields).to eq([:division_id])
    end

    it "contains child keys for polymorphic belongs to associations" do
      expect(RailsAdmin.config(Comment).fields.find{ |f| f.name == :commentable }.children_fields).to match_array POLYMORPHIC_CHILDREN
    end

    it "has correct fields when polymorphic_type column comes ahead of polymorphic foreign_key column" do
      class CommentReversed < Tableless
        column :commentable_type, :string
        column :commentable_id, :integer
        belongs_to :commentable, :polymorphic => true
      end
      expect(RailsAdmin.config(CommentReversed).fields.map{|f| f.name.to_s}.select{|f| /^comment/ =~ f}).to match_array ['commentable'].concat(POLYMORPHIC_CHILDREN.map(&:to_s))
    end

    context "of a Paperclip installation" do
      it "is a _file_name field" do
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :paperclip_asset }.children_fields.include?(:paperclip_asset_file_name)).to be_true
      end

      it "is hidden, not filterable" do
        f = RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :paperclip_asset_file_name }
        expect(f.hidden?).to be_true
        expect(f.filterable?).to be_false
      end
    end

    context "of a Dragonfly installation" do
      it "is a _name field and _uid field" do
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :dragonfly_asset }.children_fields).to eq([:dragonfly_asset_name, :dragonfly_asset_uid])
      end
    end

    context "of a Carrierwave installation" do
      it "is the parent field itself" do
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :carrierwave_asset }.children_fields).to eq([:carrierwave_asset])
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :carrierwave_asset }.hidden?).to be_false
      end
    end
  end

  describe "#html_default_value" do
    it "is default_value for new records when value is nil" do
      RailsAdmin.config Team do
        list do
          field :name do
            default_value 'default value'
          end
        end
      end
      @team = Team.new
      expect(RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.with(:object => @team).html_default_value).to eq('default value')
      @team.name = 'set value'
      expect(RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.with(:object => @team).html_default_value).to be_nil
      @team = FactoryGirl.create :team
      @team.name = nil
      expect(RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.with(:object => @team).html_default_value).to be_nil
    end
  end

  describe "#default_value" do
    it "is nil by default" do
      expect(RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.default_value).to be_nil
    end
  end

  describe "#hint" do
    it "is user customizable" do
      RailsAdmin.config Team do
        list do
          field :division do
            hint "Great Division"
          end
          field :name
        end
      end
      expect(RailsAdmin.config('Team').list.fields.find{|f| f.name == :division}.hint).to eq("Great Division") # custom
      expect(RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.hint).to eq("") # default
    end
  end

  describe "#css_class" do
    it "has a default and be user customizable" do
      RailsAdmin.config Team do
        list do
          field :division do
            css_class "custom"
          end
          field :name
        end
      end
      expect(RailsAdmin.config('Team').list.fields.find{|f| f.name == :division}.css_class).to eq("custom") # custom
      expect(RailsAdmin.config('Team').list.fields.find{|f| f.name == :division}.type_css_class).to eq("belongs_to_association_type") # type css class, non-customizable
      expect(RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.css_class).to eq("name_field") # default
    end
  end

  describe "#associated_collection_cache_all" do
    it "defaults to true if associated collection count < 100" do
      expect(RailsAdmin.config(Team).edit.fields.find{|f| f.name == :players}.associated_collection_cache_all).to be_true
    end

    it "defaults to false if associated collection count >= 100" do
      @players = 100.times.map do
        FactoryGirl.create :player
      end
      expect(RailsAdmin.config(Team).edit.fields.find{|f| f.name == :players}.associated_collection_cache_all).to be_false
    end
  end

  describe "#searchable_columns" do
    describe "for belongs_to fields" do
      it "finds label method on the opposite side for belongs_to associations by default" do
        expect(RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns.map{|c| c[:column]}).to eq(["divisions.name", "teams.division_id"])
      end

      it "searches on opposite table for belongs_to" do
        RailsAdmin.config(Team) do
          field :division do
            searchable :custom_id
          end
        end
        expect(RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns.map{|c| c[:column]}).to eq(["divisions.custom_id"])
      end

      it "searches on asked table with model name" do
        RailsAdmin.config(Team) do
          field :division do
            searchable League => :name
          end
        end
        expect(RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns).to eq([{:column=>"leagues.name", :type=>:string}])
      end

      it "searches on asked table with table name" do
        RailsAdmin.config(Team) do
          field :division do
            searchable :leagues => :name
          end
        end
        expect(RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns).to eq([{:column=>"leagues.name", :type=>:string}])
      end
    end

    describe "for basic type fields" do

      it "uses base table and find correct column type" do
        expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name == :text_field}.searchable_columns).to eq([{:column=>"field_tests.text_field", :type=>:text}])
        expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name == :integer_field}.searchable_columns).to eq([{:column=>"field_tests.integer_field", :type=>:integer}])
      end

      it "is customizable to another field on the same table" do
        RailsAdmin.config(FieldTest) do
          field :time_field do
            searchable :date_field
          end
        end
        expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name == :time_field}.searchable_columns).to eq([{:column=>"field_tests.date_field", :type=>:date}])
      end

      it "is customizable to another field on another table with :table_name" do
        RailsAdmin.config(FieldTest) do
          field :string_field do
            searchable :nested_field_tests => :title
          end
        end
        expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name == :string_field}.searchable_columns).to eq([{:column=>"nested_field_tests.title", :type=>:string}])
      end

      it "is customizable to another field on another model with ModelClass" do
        RailsAdmin.config(FieldTest) do
          field :string_field do
            searchable NestedFieldTest => :title
          end
        end
        expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name == :string_field}.searchable_columns).to eq([{:column=>"nested_field_tests.title", :type=>:string}])
      end
    end

    describe "for mapped fields" do
      it "of paperclip should find the underlying column on the base table" do
        expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name == :paperclip_asset}.searchable_columns.map{|c| c[:column]}).to eq(["field_tests.paperclip_asset_file_name"])
      end

      it "of dragonfly should find the underlying column on the base table" do
        expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name == :dragonfly_asset}.searchable_columns.map{|c| c[:column]}).to eq(["field_tests.dragonfly_asset_name"])
      end

      it "of carrierwave should find the underlying column on the base table" do
        expect(RailsAdmin.config(FieldTest).fields.find{|f| f.name == :carrierwave_asset}.searchable_columns.map{|c| c[:column]}).to eq(["field_tests.carrierwave_asset"])
      end
    end
  end


  describe "#searchable and #sortable" do
    it "is false if column is virtual, true otherwise" do
      RailsAdmin.config League do
        field :virtual_column
        field :name
      end
      @league = FactoryGirl.create :league
      expect(RailsAdmin.config('League').export.fields.find{ |f| f.name == :virtual_column }.sortable).to be_false
      expect(RailsAdmin.config('League').export.fields.find{ |f| f.name == :virtual_column }.searchable).to be_false
      expect(RailsAdmin.config('League').export.fields.find{ |f| f.name == :name }.sortable).to be_true
      expect(RailsAdmin.config('League').export.fields.find{ |f| f.name == :name }.searchable).to be_true
    end

    context "of a virtual field with children fields" do
      it "of paperclip should target the first children field" do
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :paperclip_asset }.searchable).to eq(:paperclip_asset_file_name)
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :paperclip_asset }.sortable).to eq(:paperclip_asset_file_name)
      end

      it "of dragonfly should target the first children field" do
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :dragonfly_asset }.searchable).to eq(:dragonfly_asset_name)
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :dragonfly_asset }.sortable).to eq(:dragonfly_asset_name)
      end

      it "of carrierwave should target the first children field" do
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :carrierwave_asset }.searchable).to eq(:carrierwave_asset)
        expect(RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :carrierwave_asset }.sortable).to eq(:carrierwave_asset)
      end
    end
  end

  describe "#virtual?" do
    it "is true if column has no properties, false otherwise" do
      RailsAdmin.config League do
        field :virtual_column
        field :name
      end
      @league = FactoryGirl.create :league
      expect(RailsAdmin.config('League').export.fields.find{ |f| f.name == :virtual_column }.virtual?).to be_true
      expect(RailsAdmin.config('League').export.fields.find{ |f| f.name == :name }.virtual?).to be_false
    end
  end

  describe "#default_search_operator" do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }
    let(:model_config) { RailsAdmin.config(abstract_model) }
    let(:queryable_fields) { model_config.list.fields.select(&:queryable?) }

    context "when no search operator is specified for the field" do
      it "uses 'default' search operator" do
        expect(queryable_fields).to have_at_least(1).field
        expect(queryable_fields.first.search_operator).to eq(RailsAdmin::Config.default_search_operator)
      end

      it "uses config.default_search_operator if set" do
        RailsAdmin.config do |config|
          config.default_search_operator = 'starts_with'
        end
        expect(queryable_fields).to have_at_least(1).field
        expect(queryable_fields.first.search_operator).to eq(RailsAdmin::Config.default_search_operator)
      end
    end

    context "when search operator is specified for the field" do
      it "uses specified search operator" do
        RailsAdmin.config Player do
          list do
            fields do
              search_operator "starts_with"
            end
          end
        end
        expect(queryable_fields).to have_at_least(1).field
        expect(queryable_fields.first.search_operator).to eq("starts_with")
      end

      it "uses specified search operator even if config.default_search_operator set" do
        RailsAdmin.config do |config|
          config.default_search_operator = 'starts_with'

          config.model Player do
            list do
              fields do
                search_operator "ends_with"
              end
            end
          end
        end
        expect(queryable_fields).to have_at_least(1).field
        expect(queryable_fields.first.search_operator).to eq("ends_with")
      end
    end
  end

  describe "#render" do
    it "is configurable" do
      RailsAdmin.config Team do
        field :name do
          render do
            'rendered'
          end
        end
      end
      expect(RailsAdmin.config(Team).field(:name).render).to eq('rendered')
    end
  end

  describe "#active" do
    it "is false by default" do
      expect(RailsAdmin.config(Team).field(:division).active?).to be_false
    end
  end

  describe "#associated_collection" do
    it "returns [] when type is blank?" do
      expect(RailsAdmin.config(Comment).fields.find{|f|f.name == :commentable}.associated_collection('')).to be_empty
    end
  end

  describe "#visible?" do
    it "is false when fields have specific name " do
      class FieldVisibilityTest < Tableless
        column :id, :integer
        column :_id, :integer
        column :_type, :string
        column :name, :string
        column :created_at, :datetime
        column :updated_at, :datetime
        column :deleted_at, :datetime
        column :created_on, :datetime
        column :updated_on, :datetime
        column :deleted_on, :datetime
      end
      expect(RailsAdmin.config(FieldVisibilityTest).base.fields.select{|f| f.visible? }.map(&:name)).to match_array [:_id, :created_at, :created_on, :deleted_at, :deleted_on, :id, :name, :updated_at, :updated_on]
      expect(RailsAdmin.config(FieldVisibilityTest).list.fields.select{|f| f.visible? }.map(&:name)).to match_array [:_id, :created_at, :created_on, :deleted_at, :deleted_on, :id, :name, :updated_at, :updated_on]
      expect(RailsAdmin.config(FieldVisibilityTest).edit.fields.select{|f| f.visible? }.map(&:name)).to match_array [:name]
      expect(RailsAdmin.config(FieldVisibilityTest).show.fields.select{|f| f.visible? }.map(&:name)).to match_array [:name]
    end
  end

  describe "#editable?" do
    before do
      Moped.logger.stub!(:debug) if defined?(Moped)
    end

    it "yells for non attr_accessible fields if config.yell_for_non_accessible_fields is true" do
      RailsAdmin.config do |config|
        config.yell_for_non_accessible_fields = true
        config.model FieldTest do
          field :protected_field
        end
      end
      Rails.logger.should_receive(:debug).with {|msg| msg =~ /Please add 'attr_accessible :protected_field'/ }
      editable = RailsAdmin.config(FieldTest).field(:protected_field).with(:object => FactoryGirl.create(:field_test), :view => double(:controller => double(:_attr_accessible_role => :default))).editable?
      expect(editable).to be_false
    end

    it "yells for non attr_accessible fields specified role if config.yell_for_non_accessible_fields is true" do
      RailsAdmin.config do |config|
        config.yell_for_non_accessible_fields = true
        config.model FieldTest do
          field :protected_field
        end
      end
      Rails.logger.should_receive(:debug).with {|msg| msg =~ /Please add 'attr_accessible :protected_field, :as => :admin'/ }
      editable = RailsAdmin.config(FieldTest).field(:protected_field).with(:object => FactoryGirl.create(:field_test), :view => double(:controller => double(:_attr_accessible_role => :admin))).editable?
      expect(editable).to be_false
    end

    it "does not yell for non attr_accessible fields if config.yell_for_non_accessible_fields is false" do
      RailsAdmin.config do |config|
        config.yell_for_non_accessible_fields = false
        config.model FieldTest do
          field :protected_field
        end
      end
      Rails.logger.should_not_receive(:debug).with {|msg| msg =~ /Please add 'attr_accessible :protected_field'/ }
      editable = RailsAdmin.config(FieldTest).field(:protected_field).with(:object => FactoryGirl.create(:field_test), :view => double(:controller => double(:_attr_accessible_role => :default))).editable?
      expect(editable).to be_false
    end
  end

  describe "#allowed_methods" do
    it 'includes method_name' do
      RailsAdmin.config do |config|
        config.model Team do
          field :name
        end
      end

      expect(RailsAdmin.config(Team).field(:name).allowed_methods).to eq [:name]
    end
  end
end
