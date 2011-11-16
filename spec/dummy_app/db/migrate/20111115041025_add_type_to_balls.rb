class AddTypeToBalls < ActiveRecord::Migration
  def change
    add_column :balls, :type, :string
  end
end
