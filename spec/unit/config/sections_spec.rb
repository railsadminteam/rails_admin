require 'spec_helper'

describe RailsAdmin::Config::Sections do
  
  describe "configure" do
    it "should configure without changing the section default list" do
      RailsAdmin.config Team do
        edit do
          configure :name do
            label "Renamed"
          end
        end
      end
      fields = RailsAdmin.config(Team).edit.fields
      fields.find{|f| f.name == :name }.label.should == "Renamed"
      fields.count.should >= 19 # not 1
    end

    it "should not change the section list if set" do
      RailsAdmin.config Team do
        edit do
          field :manager
          configure :name do
            label "Renamed"
          end
        end
      end
      fields = RailsAdmin.config(Team).edit.fields
      fields.first.name.should == :manager
      fields.count.should == 1 # not 19
    end
  end
  
  describe "DSL field inheritance" do
    it 'should be tested' do
      RailsAdmin.config do |config|
        config.model Fan do
          field :name do
            label do
              @label ||= "modified base #{label}"
            end
          end
          list do 
            field :name do
              label do
                @label ||= "modified list #{label}"
              end
            end
          end
          edit do 
            field :name do
              label do
                @label ||= "modified edit #{label}"
              end
            end
          end
          create do 
            field :name do
              label do
                @label ||= "modified create #{label}"
              end
            end
          end
        end
        
      end
      RailsAdmin.config(Fan).visible_fields.count.should == 1
      RailsAdmin.config(Fan).visible_fields.first.label.should == 'modified base His Name'
      RailsAdmin.config(Fan).list.visible_fields.first.label.should == 'modified list His Name'
      RailsAdmin.config(Fan).export.visible_fields.first.label.should == 'modified base His Name'
      RailsAdmin.config(Fan).edit.visible_fields.first.label.should == 'modified edit His Name'
      RailsAdmin.config(Fan).create.visible_fields.first.label.should == 'modified create His Name'
      RailsAdmin.config(Fan).update.visible_fields.first.label.should == 'modified edit His Name'
    end
  end
  
  describe "DSL group inheritance" do
    it 'should be tested' do
      RailsAdmin.config do |config|
        config.model Team do
          list do
            group "a" do
              field :founded
            end
            
            group "b" do
              field :name
              field :wins
            end
          end
          
          edit do
            group "a" do
              field :name
            end
            
            group "c" do
              field :founded
              field :wins
            end
          end
          
          update do
            group "d" do
              field :wins
            end
            
            group "e" do
              field :losses
            end
          end
        end
      end
      
      RailsAdmin.config(Team).list.visible_groups.map{|g| g.visible_fields.map(&:name) }.should == [[:founded], [:name, :wins]]
      RailsAdmin.config(Team).edit.visible_groups.map{|g| g.visible_fields.map(&:name) }.should == [[:name], [:founded, :wins]]
      RailsAdmin.config(Team).create.visible_groups.map{|g| g.visible_fields.map(&:name) }.should == [[:name], [:founded, :wins]]
      RailsAdmin.config(Team).update.visible_groups.map{|g| g.visible_fields.map(&:name) }.should == [[:name], [:founded], [:wins], [:losses]]
      RailsAdmin.config(Team).visible_groups.map{|g| g.visible_fields.map(&:name) }.flatten.count.should == 19
      RailsAdmin.config(Team).export.visible_groups.map{|g| g.visible_fields.map(&:name) }.flatten.count.should == 19
    end
  end
end