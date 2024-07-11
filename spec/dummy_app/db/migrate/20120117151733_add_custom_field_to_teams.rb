

class AddCustomFieldToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :custom_field, :string
  end
end
