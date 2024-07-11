

class AddBoolFieldOpen < ActiveRecord::Migration[6.0]
  def change
    add_column :field_tests, :open, :boolean
  end
end
