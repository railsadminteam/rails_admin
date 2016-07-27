if defined?(ActiveRecord)
  MigrationBase =
    if Rails.version >= '5.0'
      ActiveRecord::Migration[5.0]
    else
      ActiveRecord::Migration
    end
end
