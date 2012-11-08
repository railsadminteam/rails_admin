require 'spec_helper'

describe RailsAdmin::Config::Model do

  describe "#excluded?" do
    before do
      RailsAdmin.config do |config|
        config.included_models = [Comment]
      end
    end

    it "returns false when included, true otherwise" do
      expect(RailsAdmin.config(Player).excluded?).to be_true
      expect(RailsAdmin.config(Comment).excluded?).to be_false
    end
  end

  describe "#object_label" do
    before do
      RailsAdmin.config(Comment) do
        object_label_method :content
      end
    end

    it "sends object_label_method to binding[:object]" do
      c = Comment.new(:content => 'test')
      expect(RailsAdmin.config(Comment).with(:object => c).object_label).to eq('test')
    end
  end

  describe "#object_label_method" do
    it "is first of Config.label_methods if found as a column on model, or :rails_admin_default_object_label_method" do
      expect(RailsAdmin.config(Comment).object_label_method).to eq(:rails_admin_default_object_label_method)
      expect(RailsAdmin.config(Division).object_label_method).to eq(:name)
    end
  end

  describe "#label" do
    it "is pretty" do
      expect(RailsAdmin.config(Comment).label).to eq('Comment')
    end
  end

  describe "#label_plural" do
    it "is pretty" do
      expect(RailsAdmin.config(Comment).label_plural).to eq('Comments')
    end
  end

  describe "#weight" do
    it "is 0" do
      expect(RailsAdmin.config(Comment).weight).to eq(0)
    end
  end

  describe "#parent" do
    it "is nil for ActiveRecord::Base inherited models" do
      expect(RailsAdmin.config(Comment).parent).to be_nil
    end

    it "is parent model otherwise" do
      expect(RailsAdmin.config(Hardball).parent).to eq(Ball)
    end
  end

  describe "#navigation_label" do
    it "is nil if parent module is Object" do
      expect(RailsAdmin.config(Comment).navigation_label).to be_nil
    end

    it "is parent module otherwise" do
      expect(RailsAdmin.config(Cms::BasicPage).navigation_label).to eq("Cms")
    end
  end
end
