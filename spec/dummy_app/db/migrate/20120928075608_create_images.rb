

class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string :file_file_name
      t.string :file_content_type
      t.bigint :file_file_size
      t.datetime :file_updated_at
      t.timestamps null: false
    end
  end
end
