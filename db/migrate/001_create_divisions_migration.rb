class CreateDivisionsMigration < ActiveRecord::Migration
  def self.up
    create_table :divisions do |t|
      t.timestamps
      t.integer :league_id
      t.string :name, :limit => 50, :null => false
    end
  end

  def self.down
    drop_table(:divisions)
  end
end
