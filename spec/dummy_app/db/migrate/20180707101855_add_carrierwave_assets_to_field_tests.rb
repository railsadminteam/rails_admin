class AddCarrierwaveAssetsToFieldTests < MigrationBase
  def change
    add_column :field_tests, :carrierwave_assets, :string, after: :carrierwave_asset
  end
end
