class ChangeDivisionPrimaryKey < ActiveRecord::Migration
  def up
    drop_table :divisions
    create_table :divisions, :primary_key => 'custom_id' do |t|
      t.timestamps
      t.integer :league_id
      t.string :name, :limit => 50, :null => false
    end
  end

  def down
    drop_table :divisions
    create_table :divisions do |t|
      t.timestamps
      t.integer :league_id
      t.string :name, :limit => 50, :null => false
    end
  end
end
