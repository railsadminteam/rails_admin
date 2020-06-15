class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.attachment :file
      t.timestamps null: false
    end
  end
end
