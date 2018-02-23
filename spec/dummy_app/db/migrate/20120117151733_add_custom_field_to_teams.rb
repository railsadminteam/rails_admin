class AddCustomFieldToTeams < MigrationBase
  def change
    add_column :teams, :custom_field, :string
  end
end
