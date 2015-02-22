class DropRelTests < ActiveRecord::Migration
  def self.up
    drop_table :rel_tests
  end

  def self.down
    create_table :rel_tests do |t|
      t.integer :league_id
      t.integer :division_id, null: false
      t.integer :player_id

      t.timestamps null: false
    end
  end
end
