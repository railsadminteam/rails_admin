# frozen_string_literal: true

class AddNonNullableBooleanField < ActiveRecord::Migration[6.0]
  def change
    add_column :field_tests, :non_nullable_boolean_field, :boolean, null: false, default: false
  end
end
