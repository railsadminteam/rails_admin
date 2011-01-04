class AddAmateurToLeagueMigration < ActiveRecord::Migration
  def self.up
    add_column :leagues, :amateur, :binary, :default => false
  end

  def self.down
    remove_column :leagues, :amateur
  end
end
