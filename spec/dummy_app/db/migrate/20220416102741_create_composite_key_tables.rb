

class CreateCompositeKeyTables < ActiveRecord::Migration[6.0]
  def change
    add_column :fans_teams, :since, :date

    create_table :favorite_players, primary_key: %i[fan_id team_id player_id] do |t|
      t.integer :fan_id, null: false
      t.integer :team_id, null: false
      t.integer :player_id, null: false
      t.string :reason

      t.timestamps
    end
  end
end
