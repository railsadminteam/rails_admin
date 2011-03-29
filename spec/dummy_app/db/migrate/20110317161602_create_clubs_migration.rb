class CreateClubsMigration < ActiveRecord::Migration
  def self.up
    create_table :clubs do |t|
      t.string  :name
      t.boolean :disabled

      t.timestamps
    end
  end

  def self.down
    drop_table :clubs
  end
end
