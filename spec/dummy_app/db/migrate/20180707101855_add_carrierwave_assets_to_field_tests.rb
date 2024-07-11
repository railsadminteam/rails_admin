

class AddCarrierwaveAssetsToFieldTests < ActiveRecord::Migration[5.0]
  def change
    add_column :field_tests, :carrierwave_assets, :string, after: :carrierwave_asset
  end
end
