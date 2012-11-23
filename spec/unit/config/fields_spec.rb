require 'spec_helper'

describe RailsAdmin::Config::Fields, :mongoid => true do
  describe '.factory for self.referentials belongs_to' do
    it 'associates belongs_to _id foreign_key to a belongs_to association' do
      class MongoTree
        include Mongoid::Document
        has_many :children, :class_name => self.name, :foreign_key => :parent_id
        belongs_to :parent, :class_name => self.name
      end

      expect(RailsAdmin.config(MongoTree).fields.find{ |f| f.name == :parent }.type ).to eq :belongs_to_association
    end
  end
end
