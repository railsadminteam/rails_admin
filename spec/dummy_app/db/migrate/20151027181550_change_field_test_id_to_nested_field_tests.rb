

class ChangeFieldTestIdToNestedFieldTests < ActiveRecord::Migration[5.0]
  def change
    change_column :nested_field_tests, :field_test_id, :integer, null: false
  end
end
