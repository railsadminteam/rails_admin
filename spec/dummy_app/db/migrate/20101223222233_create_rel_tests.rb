class CreateRelTests < ActiveRecord::Migration
  def self.up
    create_table :rel_tests do |t|
      t.integer :league_id
      t.integer :division_id, :null => false
      t.integer :player_id

      t.timestamps
    end
  end

  def self.down
    drop_table :rel_tests
  end
end
