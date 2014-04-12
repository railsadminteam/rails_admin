class CreateDeeplyNestedFieldTests < ActiveRecord::Migration
  def change
    create_table :deeply_nested_field_tests do |t|
      t.belongs_to :nested_field_test
      t.string :title
      t.timestamps
    end
  end
end
