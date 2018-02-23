class CreateImages < MigrationBase
  def change
    create_table :images do |t|
      t.attachment :file
      t.timestamps null: false
    end
  end
end
