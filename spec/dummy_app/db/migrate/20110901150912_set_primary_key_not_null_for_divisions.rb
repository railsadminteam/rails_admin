class SetPrimaryKeyNotNullForDivisions < ActiveRecord::Migration
  def up
    drop_table :divisions
    create_table :divisions, :id => false do |t|
      t.timestamps
      t.primary_key :custom_id
      t.integer :custom_league_id
      t.string :name, :limit => 50, :null => false
    end

  end

  def down
    drop_table :divisions
    create_table :divisions, :primary_key => :custom_id do |t|
      t.timestamps
      t.integer :custom_league_id
      t.string :name, :limit => 50, :null => false
    end
  end
end
