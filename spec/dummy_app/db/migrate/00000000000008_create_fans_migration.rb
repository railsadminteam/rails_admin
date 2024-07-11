

class CreateFansMigration < ActiveRecord::Migration[5.0]
  def self.up
    create_table :fans do |t|
      t.timestamps null: false
      t.string :name, limit: 100, null: false
    end
  end

  def self.down
    drop_table :fans
  end
end
