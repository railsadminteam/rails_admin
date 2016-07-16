class CreateLeaguesMigration < MigrationBase
  def self.up
    create_table :leagues do |t|
      t.timestamps null: false
      t.string :name, limit: 50, null: false
    end
  end

  def self.down
    drop_table :leagues
  end
end
