class AddDragonflyAssetNameToFieldTests < ActiveRecord::Migration
  def change
    add_column :field_tests, :dragonfly_asset_name, :string
  end
end
