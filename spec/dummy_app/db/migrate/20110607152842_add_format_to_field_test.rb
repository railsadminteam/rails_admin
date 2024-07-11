

class AddFormatToFieldTest < ActiveRecord::Migration[5.0]
  def self.up
    add_column :field_tests, :format, :string
  end

  def self.down
    remove_column :field_tests, :format
  end
end
