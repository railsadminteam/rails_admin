

class AddDragonflyAndCarrierwaveToFieldTests < ActiveRecord::Migration[5.0]
  def change
    add_column :field_tests, :paperclip_asset_file_name, :string
    add_column :field_tests, :dragonfly_asset_uid, :string
    add_column :field_tests, :carrierwave_asset, :string
  end
end
