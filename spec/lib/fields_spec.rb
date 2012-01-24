require 'spec_helper'

describe RailsAdmin::Config::Fields::Base do
  describe '#searchable_columns' do
    describe 'for belongs_to fields' do
      it "should find label method on the opposite side for belongs_to associations by default" do
        RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns.should == [{:column=>"divisions.name", :type=>:string}, {:column=>"teams.division_id", :type=>:integer}]
      end
    
      it "should search on opposite table for belongs_to" do
        RailsAdmin.config(Team) do
          field :division do
            searchable :custom_id
          end
        end
        RailsAdmin.config(Team).fields.find{|f| f.name == :division}.searchable_columns.should == [{:column=>"divisions.custom_id", :type=>:integer}]
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
      
      it 'should find the underlying column on the base table' do
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :paperclip_asset}.searchable_columns.should == [{:column=>"field_tests.paperclip_asset_file_name", :type=>:string}]
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :dragonfly_asset}.searchable_columns.should == [{:column=>"field_tests.dragonfly_asset_name", :type=>:string}]
        RailsAdmin.config(FieldTest).fields.find{|f| f.name == :carrierwave_asset}.searchable_columns.should == [{:column=>"field_tests.carrierwave_asset", :type=>:string}]
      end
    end
  end
end