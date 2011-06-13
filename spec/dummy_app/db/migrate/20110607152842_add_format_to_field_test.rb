class AddFormatToFieldTest < ActiveRecord::Migration
  def self.up
    add_column :field_tests, :format, :string
  end

  def self.down
    remove_column :field_tests, :format
  end
end
