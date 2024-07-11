

class AddRolesToUser < ActiveRecord::Migration[5.0]
  def self.up
    add_column :users, :roles, :string
  end

  def self.down
    remove_column :users, :roles
  end
end
