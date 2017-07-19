class AddTypeToBalls < MigrationBase
  def change
    add_column :balls, :type, :string
  end
end
