class ChangeFieldTestIdToNestedFieldTests < MigrationBase
  def change
    change_column :nested_field_tests, :field_test_id, :integer, null: false
  end
end
