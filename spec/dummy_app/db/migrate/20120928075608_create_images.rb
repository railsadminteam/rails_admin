class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.attachment :file
      t.timestamps
    end
  end
end
