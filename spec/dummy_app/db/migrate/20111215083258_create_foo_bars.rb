

class CreateFooBars < ActiveRecord::Migration[5.0]
  def change
    create_table :foo_bars do |t|
      t.string :title
      t.timestamps null: false
    end
  end
end
