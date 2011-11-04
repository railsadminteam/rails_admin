class CreateHistoriesTable < ActiveRecord::Migration
   def self.up
     create_table :histories do |t|
       t.string :message # title, name, or object_id
       t.string :username
       t.integer :item
       t.string :table
       t.timestamps
    end
    add_index(:histories, [:item, :table])
  end

  def self.down
    drop_table :histories
  end
end
