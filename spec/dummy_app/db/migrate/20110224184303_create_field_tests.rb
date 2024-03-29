# frozen_string_literal: true

class CreateFieldTests < ActiveRecord::Migration[5.0]
  def self.up
    create_table :field_tests do |t|
      t.string :string_field
      t.text :text_field
      t.integer :integer_field
      t.float :float_field
      t.decimal :decimal_field
      t.datetime :datetime_field
      t.timestamp :timestamp_field
      t.time :time_field
      t.date :date_field
      t.boolean :boolean_field

      t.timestamps null: false
    end
  end

  def self.down
    drop_table :field_tests
  end
end
