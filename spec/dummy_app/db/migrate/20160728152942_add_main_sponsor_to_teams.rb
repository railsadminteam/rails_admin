

class AddMainSponsorToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :main_sponsor, :integer, default: 0, null: false
  end
end
