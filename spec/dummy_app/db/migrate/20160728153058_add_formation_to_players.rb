class AddFormationToPlayers < MigrationBase
  def change
    add_column :players, :formation, :string, default: 'substitute', null: false
  end
end
