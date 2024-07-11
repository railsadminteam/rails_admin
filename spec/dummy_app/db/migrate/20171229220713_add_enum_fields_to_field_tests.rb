

class AddEnumFieldsToFieldTests < ActiveRecord::Migration[5.0]
  def change
    add_column :field_tests, :string_enum_field,  :string
    add_column :field_tests, :integer_enum_field, :integer
  end
end
