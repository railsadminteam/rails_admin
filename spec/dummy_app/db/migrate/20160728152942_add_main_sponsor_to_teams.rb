class AddMainSponsorToTeams < MigrationBase
  def change
    add_column :teams, :main_sponsor, :integer, default: 0, null: false
  end
end
