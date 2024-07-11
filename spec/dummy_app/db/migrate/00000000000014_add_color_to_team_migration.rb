

class AddColorToTeamMigration < ActiveRecord::Migration[5.0]
  def self.up
    add_column :teams, :color, :string
  end

  def self.down
    remove_column :teams, :color
  end
end
