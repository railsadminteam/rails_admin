class CreateDeeplyNestedFieldTests < MigrationBase
  def change
    create_table :deeply_nested_field_tests do |t|
      t.belongs_to :nested_field_test
      t.string :title
      t.timestamps null: false
    end
  end
end
