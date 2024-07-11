

class UpdateActiveStorageTables < ActiveRecord::Migration[5.0]
  def change
    add_column :active_storage_blobs, :service_name, :string, null: false, default: 'local'
    create_table :active_storage_variant_records do |t|
      t.belongs_to :blob, null: false, index: false
      t.string :variation_digest, null: false

      t.index %i[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
    end
  end
end
