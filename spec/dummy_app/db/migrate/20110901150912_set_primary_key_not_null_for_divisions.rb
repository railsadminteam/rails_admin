

class SetPrimaryKeyNotNullForDivisions < ActiveRecord::Migration[5.0]
  def up
    drop_table :divisions
    create_table :divisions, id: false do |t|
      t.timestamps null: false
      t.primary_key :custom_id
      t.integer :custom_league_id
      t.string :name, limit: 50, null: false
    end
  end

  def down
    drop_table :divisions
    create_table :divisions, primary_key: :custom_id do |t|
      t.timestamps null: false
      t.integer :custom_league_id
      t.string :name, limit: 50, null: false
    end
  end
end
