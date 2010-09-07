class CreateHistoriesTable < ActiveRecord::Migration
   def self.up
     create_table :histories do |t|
       t.integer :action, :limit => 4
       t.integer :month, :limit => 2
       t.integer :year, :limit => 5
       t.string :table
       t.string :other # => title, name or just object_id
       t.integer :user_id
       #Any additional fields here

       t.timestamps
    end
    add_index(:histories, [:month,:year])
  end

  def self.down
    drop_table :accounts
  end
end