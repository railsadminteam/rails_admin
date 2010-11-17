class AddSuspendedToPlayerMigration < ActiveRecord::Migration
  def self.up
    add_column :players, :suspended, :boolean, :default => false
  end

  def self.down
    remove_column :players, :suspended
  end
end
