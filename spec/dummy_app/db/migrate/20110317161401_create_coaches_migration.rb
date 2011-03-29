class CreateCoachesMigration < ActiveRecord::Migration
  def self.up
    create_table :coaches do |t|
      t.string  :name
      t.boolean :disabled

      t.timestamps
    end
  end

  def self.down
    drop_table :coaches
  end
end
