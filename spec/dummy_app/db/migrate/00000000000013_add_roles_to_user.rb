  class AddRolesToUser < ActiveRecord::Migration
    def self.up
      add_column :users, :roles, :string
    end

    def self.down
      remove_column :users, :roles
    end
  end
