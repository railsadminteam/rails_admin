

class AddTypeToBalls < ActiveRecord::Migration[5.0]
  def change
    add_column :balls, :type, :string
  end
end
