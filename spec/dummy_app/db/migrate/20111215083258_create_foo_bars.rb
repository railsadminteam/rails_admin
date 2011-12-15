class CreateFooBars < ActiveRecord::Migration
  def change
    create_table :foo_bars do |t|
      t.string :title
      t.timestamps
    end
  end
end
