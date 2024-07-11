

class CreateBalls < ActiveRecord::Migration[5.0]
  def self.up
    create_table :balls, force: true do |t|
      t.string :color
      t.timestamps null: false
    end
  end

  def self.down
    drop_table :balls
  end
end
