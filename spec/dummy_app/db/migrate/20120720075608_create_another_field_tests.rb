class CreateAnotherFieldTests < ActiveRecord::Migration
  def change
    create_table :another_field_tests do |t|
      t.timestamps
    end
    add_column :nested_field_tests, :another_field_test_id, :integer
  end
end
