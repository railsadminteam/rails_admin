

class AddRefileToFieldTests < ActiveRecord::Migration[5.0]
  def change
    add_column :field_tests, :refile_asset_id, :string
    add_column :field_tests, :refile_asset_filename, :string
    add_column :field_tests, :refile_asset_size, :string
    add_column :field_tests, :refile_asset_content_type, :string
  end
end
