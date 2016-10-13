class CreateCase < MigrationBase
  def change
    create_table :cases do |t|
      t.string  :name
      t.integer :test_id, null: false
    end
  end
end

