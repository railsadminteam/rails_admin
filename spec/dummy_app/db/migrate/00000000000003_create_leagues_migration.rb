class CreateLeaguesMigration < ActiveRecord::Migration
  def self.up
    create_table :leagues do |t|
      t.timestamps
      t.string :name, :limit => 50, :null => false
    end
  end

  def self.down
    drop_table :leagues
  end
end
