

class AddFormationToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :formation, :string, default: 'substitute', null: false
  end
end
