

class ChangeLengthForRailsAdminHistories < ActiveRecord::Migration[5.0]
  def up
    change_column :rails_admin_histories, :message, :text
  end

  def down
    change_column :rails_admin_histories, :message, :string
  end
end
