

class AddSuspendedToPlayerMigration < ActiveRecord::Migration[5.0]
  def self.up
    add_column :players, :suspended, :boolean, default: false
  end

  def self.down
    remove_column :players, :suspended
  end
end
