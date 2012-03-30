require 'spec_helper'

describe 'table relations' do

  before(:each) do
    class RelTest < Tableless
      column :league_id, :integer
      column :division_id, :integer, nil, false
      column :player_id, :integer
      belongs_to :league
      belongs_to :division
      belongs_to :player
      validates_numericality_of(:player_id, :only_integer => true)
    end
    @fields = RailsAdmin.config(RelTest).create.fields
  end

  describe 'column with nullable fk and no model validations' do
    it 'should be optional' do
      @fields.find{ |f| f.name == :league }.required?.should == false
    end
  end

  describe 'column with non-nullable fk and no model validations' do
    it 'should not be required' do
      @fields.find{ |f| f.name == :division }.required?.should == false
    end
  end

  describe 'column with nullable fk and a numericality model validation' do
    it 'should be required' do
      @fields.find{ |f| f.name == :player }.required?.should == true
    end
  end
end
