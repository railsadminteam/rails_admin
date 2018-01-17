class AddSizeEnumToFieldTests < MigrationBase
  def change
    add_column :field_tests, :size_string_enum,  :string
    add_column :field_tests, :size_integer_enum, :integer
  end
end
