module DatabaseHelpers

  def migrate_database
    silence_stream(STDOUT) do
      ActiveRecord::Migrator.migrate File.expand_path('../dummy_app/db/migrate/', __FILE__)
    end
  end

  def drop_all_tables
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
  end

end
