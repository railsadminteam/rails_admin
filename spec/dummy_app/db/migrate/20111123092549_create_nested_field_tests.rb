class CreateNestedFieldTests < ActiveRecord::Migration
  def change
    create_table :nested_field_tests do |t|
      t.string :title
      t.integer :field_test_id

      t.timestamps
    end
  end
end
