class AddUuidFieldToFieldTests < ActiveRecord::Migration
  def change
    add_column :field_tests, :uuid_field, :uuid
  end
end
