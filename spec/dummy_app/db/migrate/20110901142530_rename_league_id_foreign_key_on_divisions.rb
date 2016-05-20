class RenameLeagueIdForeignKeyOnDivisions < MigrationBase
  def change
    rename_column :divisions, :league_id, :custom_league_id
  end
end
