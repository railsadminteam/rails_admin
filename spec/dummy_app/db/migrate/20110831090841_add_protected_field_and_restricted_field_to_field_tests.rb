

class AddProtectedFieldAndRestrictedFieldToFieldTests < ActiveRecord::Migration[5.0]
  def change
    add_column :field_tests, :restricted_field, :string
    add_column :field_tests, :protected_field, :string
  end
end
