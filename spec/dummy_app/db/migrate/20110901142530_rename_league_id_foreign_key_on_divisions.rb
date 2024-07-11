

class RenameLeagueIdForeignKeyOnDivisions < ActiveRecord::Migration[5.0]
  def change
    rename_column :divisions, :league_id, :custom_league_id
  end
end
