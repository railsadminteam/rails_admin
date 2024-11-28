# frozen_string_literal: true

class AddDragonflyAssetNameToFieldTests < ActiveRecord::Migration[5.0]
  def change
    add_column :field_tests, :dragonfly_asset_name, :string
  end
end
