require 'spec_helper'

describe RailsAdmin::Config::Model do

  describe "#excluded?" do
    before do
      RailsAdmin.config do |config|
        config.included_models = [Comment]
      end
    end

    it "should say false when included, true otherwise" do
      RailsAdmin.config(Player).excluded?.should == true
      RailsAdmin.config(Comment).excluded?.should == false
    end
  end

  describe "#object_label" do
    before do
      RailsAdmin.config(Comment) do
        object_label_method :content
      end
    end

    it "should send object_label_method to binding[:object]" do
      c = Comment.new(:content => 'test')
      RailsAdmin.config(Comment).with(:object => c).object_label.should == 'test'
    end
  end

  describe "#object_label_method" do
    it "should be first of Config.label_methods if found as a column on model, or :rails_admin_default_object_label_method" do
      RailsAdmin.config(Comment).object_label_method.should == :rails_admin_default_object_label_method
      RailsAdmin.config(Division).object_label_method.should == :name
    end
  end

  describe "#label" do
    it "should be pretty" do
      RailsAdmin.config(Comment).label.should == 'Comment'
    end
  end

  describe "#label_plural" do
    it "should be pretty" do
      RailsAdmin.config(Comment).label_plural.should == 'Comments'
    end
  end

  describe "#weight" do
    it "should be 0" do
      RailsAdmin.config(Comment).weight.should == 0
    end
  end

  describe "#parent" do
    it "should be nil for ActiveRecord::Base inherited models" do
      RailsAdmin.config(Comment).parent.should be_nil
    end

    it "should be parent model otherwise" do
      RailsAdmin.config(Hardball).parent.should == Ball
    end
  end

  describe "#navigation_label" do
    it "should be nil if parent module is Object" do
      RailsAdmin.config(Comment).navigation_label.should be_nil
    end

    it "should be parent module otherwise" do
      RailsAdmin.config(Cms::BasicPage).navigation_label.should == "Cms"
    end
  end
end
