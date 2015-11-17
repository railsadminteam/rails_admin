class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :name
    end

    create_table :promotion_participations do |t|
      t.integer :promotion_id
      t.integer :user_id
    end
  end
end
