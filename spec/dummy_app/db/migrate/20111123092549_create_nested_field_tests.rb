class CreateNestedFieldTests < MigrationBase
  def change
    create_table :nested_field_tests do |t|
      t.string :title
      t.integer :field_test_id

      t.timestamps null: false
    end
  end
end
