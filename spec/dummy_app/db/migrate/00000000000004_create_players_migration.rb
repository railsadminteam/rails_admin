class CreatePlayersMigration < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.timestamps
      t.datetime :deleted_at
      t.integer :team_id
      t.string :name, :limit => 100, :null => false
      t.string :position, :limit => 50
      t.integer :number, :null => false
      t.boolean :retired, :default => false
      t.boolean :injured, :default => false
      t.date :born_on
      t.text :notes
    end
  end

  def self.down
    drop_table :players
  end
end
