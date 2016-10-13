class CreateTests < MigrationBase
  def change
    create_table :tests do |t|
      t.string :name
    end
  end
end

