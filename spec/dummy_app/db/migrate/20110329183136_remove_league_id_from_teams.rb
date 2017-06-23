class RemoveLeagueIdFromTeams < MigrationBase
  def self.up
    remove_column :teams, :league_id
  end

  def self.down
    add_column :teams, :league_id, :integer
  end
end
