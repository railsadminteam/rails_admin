require 'spec_helper'

describe RailsAdmin::Config::Fields::Base do

  describe "#name" do
    it 'should be normalized to Symbol' do
      RailsAdmin.config Team do
        field 'name'
      end
      RailsAdmin.config('Team').fields.first.name.should == :name
    end
  end

  describe "#children_fields" do
    POLYMORPHIC_CHILDREN =
      if CI_ORM == :mongoid && Mongoid::VERSION >= '3.0.0'
        [:commentable_id, :commentable_type, :commentable_field]
      else
        [:commentable_id, :commentable_type]
      end

    it 'should be empty by default' do
      RailsAdmin.config(Team).fields.find{ |f| f.name == :name }.children_fields.should == []
    end

    it 'should contain child key for belongs to associations' do
      RailsAdmin.config(Team).fields.find{ |f| f.name == :division }.children_fields.should == [:division_id]
    end

    it 'should contain child keys for polymorphic belongs to associations' do
      RailsAdmin.config(Comment).fields.find{ |f| f.name == :commentable }.children_fields.should =~ POLYMORPHIC_CHILDREN
    end

    it "should have correct fields when polymorphic_type column comes ahead of polymorphic foreign_key column" do
      class CommentReversed < Tableless
        column :commentable_type, :string
        column :commentable_id, :integer
        belongs_to :commentable, :polymorphic => true
      end
      RailsAdmin.config(CommentReversed).fields.map{|f| f.name.to_s}.
        select{|f| /^comment/ =~ f}.should =~ ['commentable'].concat(POLYMORPHIC_CHILDREN.map(&:to_s))
    end

    context 'of a Paperclip installation' do
      it 'should be a _file_name field' do
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :paperclip_asset }.children_fields.include?(:paperclip_asset_file_name).should be_true
      end

      it 'should be hidden, not filterable' do
        f = RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :paperclip_asset_file_name }
        f.hidden?.should be_true
        f.filterable?.should be_false
      end
    end

    context 'of a Dragonfly installation' do
      it 'should be a _name field and _uid field' do
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :dragonfly_asset }.children_fields.should == [:dragonfly_asset_name, :dragonfly_asset_uid]
      end
    end

    context 'of a Carrierwave installation' do
      it 'should be the parent field itself' do
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :carrierwave_asset }.children_fields.should == [:carrierwave_asset]
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :carrierwave_asset }.hidden?.should be_false
      end
    end
  end

  describe "#html_default_value" do
    it 'should be default_value for new records when value is nil' do
      RailsAdmin.config Team do
        list do
          field :name do
            default_value 'default value'
          end
        end
      end
      @team = Team.new
      RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.with(:object => @team).html_default_value.should == 'default value'
      @team.name = 'set value'
      RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.with(:object => @team).html_default_value.should be_nil
      @team = FactoryGirl.create :team
      @team.name = nil
      RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.with(:object => @team).html_default_value.should be_nil
    end
  end

  describe "#default_value" do
    it 'should be nil by default' do
      RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.default_value.should be_nil
    end
  end

  describe "#hint" do
    it "should be user customizable" do
      RailsAdmin.config Team do
        list do
          field :division do
            hint "Great Division"
          end
          field :name
        end
      end
      RailsAdmin.config('Team').list.fields.find{|f| f.name == :division}.hint.should == "Great Division" # custom
      RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.hint.should == "" # default
    end
  end

  describe "#css_class" do
    it "should have a default and be user customizable" do
      RailsAdmin.config Team do
        list do
          field :division do
            css_class "custom"
          end
          field :name
        end
      end
      RailsAdmin.config('Team').list.fields.find{|f| f.name == :division}.css_class.should == "custom" # custom
      RailsAdmin.config('Team').list.fields.find{|f| f.name == :division}.type_css_class.should == "belongs_to_association_type" # type css class, non-customizable
      RailsAdmin.config('Team').list.fields.find{|f| f.name == :name}.css_class.should == "name_field" # default
    end
  end

  describe "#associated_collection_cache_all" do
    it "should default to true if associated collection count < 100" do
      RailsAdmin.config(Team).edit.fields.find{|f| f.name == :players}.associated_collection_cache_all.should == true
    end

    it "should default to false if associated collection count >= 100" do
      @players = 100.times.map do
        FactoryGirl.create :player
      end
      RailsAdmin.config(Team).edit.fields.find{|f| f.name == :players}.associated_collection_cache_all.should == false
    end
  end

  describe '#searchable_columns' do
    describe 'for belongs_to fields' do
      it "should find label method on the opposite side for belongs_to associations by default" do
        RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns.map{|c| c[:column]}.should == ["divisions.name", "teams.division_id"]
      end

      it "should search on opposite table for belongs_to" do
        RailsAdmin.config(Team) do
          field :division do
            searchable :custom_id
          end
        end
        RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns.map{|c| c[:column]}.should == ["divisions.custom_id"]
      end

      it "should search on asked table with model name" do
        RailsAdmin.config(Team) do
          field :division do
            searchable League => :name
          end
        end
        RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns.should == [{:column=>"leagues.name", :type=>:string}]
      end

      it "should search on asked table with table name" do
        RailsAdmin.config(Team) do
          field :division do
            searchable :leagues => :name
          end
        end
        RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns.should == [{:column=>"leagues.name", :type=>:string}]
      end
    end

    describe 'for basic type fields' do

      it 'should use base table and find correct column type' do
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :text_field}.searchable_columns.should == [{:column=>"field_tests.text_field", :type=>:text}]
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :integer_field}.searchable_columns.should == [{:column=>"field_tests.integer_field", :type=>:integer}]
      end

      it 'should be customizable to another field on the same table' do
        RailsAdmin.config(FieldTest) do
          field :time_field do
            searchable :date_field
          end
        end
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :time_field}.searchable_columns.should == [{:column=>"field_tests.date_field", :type=>:date}]
      end

      it 'should be customizable to another field on another table with :table_name' do
        RailsAdmin.config(FieldTest) do
          field :string_field do
            searchable :nested_field_tests => :title
          end
        end
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :string_field}.searchable_columns.should == [{:column=>"nested_field_tests.title", :type=>:string}]
      end

      it 'should be customizable to another field on another model with ModelClass' do
        RailsAdmin.config(FieldTest) do
          field :string_field do
            searchable NestedFieldTest => :title
          end
        end
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :string_field}.searchable_columns.should == [{:column=>"nested_field_tests.title", :type=>:string}]
      end
    end

    describe 'for mapped fields' do
      it 'of paperclip should find the underlying column on the base table' do
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :paperclip_asset}.searchable_columns.map{|c| c[:column]}.should == ["field_tests.paperclip_asset_file_name"]
      end

      it 'of dragonfly should find the underlying column on the base table' do
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :dragonfly_asset}.searchable_columns.map{|c| c[:column]}.should == ["field_tests.dragonfly_asset_name"]
      end

      it 'of carrierwave should find the underlying column on the base table' do
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :carrierwave_asset}.searchable_columns.map{|c| c[:column]}.should == ["field_tests.carrierwave_asset"]
      end
    end
  end


  describe "#searchable and #sortable" do
    it 'should be false if column is virtual, true otherwise' do
      RailsAdmin.config League do
        field :virtual_column
        field :name
      end
      @league = FactoryGirl.create :league
      RailsAdmin.config('League').export.fields.find{ |f| f.name == :virtual_column }.sortable.should == false
      RailsAdmin.config('League').export.fields.find{ |f| f.name == :virtual_column }.searchable.should == false
      RailsAdmin.config('League').export.fields.find{ |f| f.name == :name }.sortable.should == true
      RailsAdmin.config('League').export.fields.find{ |f| f.name == :name }.searchable.should == true
    end

    context 'of a virtual field with children fields' do
      it 'of paperclip should target the first children field' do
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :paperclip_asset }.searchable.should == :paperclip_asset_file_name
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :paperclip_asset }.sortable.should == :paperclip_asset_file_name
      end

      it 'of dragonfly should target the first children field' do
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :dragonfly_asset }.searchable.should == :dragonfly_asset_name
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :dragonfly_asset }.sortable.should == :dragonfly_asset_name
      end

      it 'of carrierwave should target the first children field' do
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :carrierwave_asset }.searchable.should == :carrierwave_asset
        RailsAdmin.config(FieldTest).fields.find{ |f| f.name == :carrierwave_asset }.sortable.should == :carrierwave_asset
      end
    end
  end

  describe "#virtual?" do
    it 'should be true if column has no properties, false otherwise' do
      RailsAdmin.config League do
        field :virtual_column
        field :name
      end
      @league = FactoryGirl.create :league
      RailsAdmin.config('League').export.fields.find{ |f| f.name == :virtual_column }.virtual?.should == true
      RailsAdmin.config('League').export.fields.find{ |f| f.name == :name }.virtual?.should == false
    end
  end

  describe "#default_search_operator" do
    let(:abstract_model) { RailsAdmin::AbstractModel.new('Player') }
    let(:model_config) { RailsAdmin.config(abstract_model) }
    let(:queryable_fields) { model_config.list.fields.select(&:queryable?) }

    context "when no search operator is specified for the field" do
      it "uses 'default' search operator" do
        queryable_fields.should have_at_least(1).field
        queryable_fields.first.search_operator.should == RailsAdmin::Config.default_search_operator
      end

      it "uses config.default_search_operator if set" do
        RailsAdmin.config do |config|
          config.default_search_operator = 'starts_with'
        end
        queryable_fields.should have_at_least(1).field
        queryable_fields.first.search_operator.should == RailsAdmin::Config.default_search_operator
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
        queryable_fields.should have_at_least(1).field
        queryable_fields.first.search_operator.should == "starts_with"
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
        queryable_fields.should have_at_least(1).field
        queryable_fields.first.search_operator.should == "ends_with"
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
      RailsAdmin.config(Team).field(:name).render.should == 'rendered'
    end
  end

  describe '#active' do
    it 'is false by default' do
      RailsAdmin.config(Team).field(:division).active?.should be_false
    end
  end
  
  describe '#associated_collection' do
    it 'returns [] when type is blank?' do
      RailsAdmin.config(Comment).fields.find{|f|f.name == :commentable}.associated_collection('').should be_empty
    end
  end

  describe '#visible?' do
    it "should be false when fields have specific name " do
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
      RailsAdmin.config(FieldVisibilityTest).base.fields.select{|f| f.visible? }.map(&:name).should =~ [:_id, :created_at, :created_on, :deleted_at, :deleted_on, :id, :name, :updated_at, :updated_on]
      RailsAdmin.config(FieldVisibilityTest).list.fields.select{|f| f.visible? }.map(&:name).should =~ [:_id, :created_at, :created_on, :deleted_at, :deleted_on, :id, :name, :updated_at, :updated_on]
      RailsAdmin.config(FieldVisibilityTest).edit.fields.select{|f| f.visible? }.map(&:name).should =~ [:name]
      RailsAdmin.config(FieldVisibilityTest).show.fields.select{|f| f.visible? }.map(&:name).should =~ [:name]
    end
  end
end
