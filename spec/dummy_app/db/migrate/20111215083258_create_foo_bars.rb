class CreateFooBars < ActiveRecord::Migration
  def change
    create_table :foo_bars do |t|
      t.string :title
      t.timestamps null: false
    end
  end
end
