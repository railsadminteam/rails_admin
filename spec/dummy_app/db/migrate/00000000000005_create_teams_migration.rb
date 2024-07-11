

class CreateTeamsMigration < ActiveRecord::Migration[5.0]
  def self.up
    create_table :teams do |t|
      t.timestamps null: false
      t.integer :league_id
      t.integer :division_id
      t.string :name, limit: 50
      t.string :logo_url, limit: 255
      t.string :manager, limit: 100, null: false
      t.string :ballpark, limit: 100
      t.string :mascot, limit: 100
      t.integer :founded
      t.integer :wins
      t.integer :losses
      t.float :win_percentage
    end
  end

  def self.down
    drop_table :teams
  end
end
