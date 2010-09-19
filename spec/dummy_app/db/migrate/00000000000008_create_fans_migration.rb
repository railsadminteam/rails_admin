class CreateFansMigration < ActiveRecord::Migration
  def self.up
    create_table :fans do |t|
      t.timestamps
      t.string :name, :limit => 100, :null => false
    end
  end

  def self.down
    drop_table :fans
  end
end
