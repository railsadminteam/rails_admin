

class CreateComments < ActiveRecord::Migration[5.0]
  def self.up
    create_table :comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.text :content

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :comments
  end
end
