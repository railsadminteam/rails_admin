class AddRevenueToTeamMigration < ActiveRecord::Migration
  def self.up
    add_column :teams, :revenue, :decimal, :precision => 18, :scale => 2
  end

  def self.down
    remove_column :teams, :revenue
  end
end
