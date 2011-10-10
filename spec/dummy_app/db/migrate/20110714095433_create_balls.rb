class CreateBalls < ActiveRecord::Migration
  def self.up
    create_table :balls, :force => true do |t|
      t.string :color
      t.timestamps
    end
  end

  def self.down
    drop_table :balls
  end
end
