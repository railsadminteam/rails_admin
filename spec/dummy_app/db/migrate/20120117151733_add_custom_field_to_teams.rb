class AddCustomFieldToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :custom_field, :string
  end
end
