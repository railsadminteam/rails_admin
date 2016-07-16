if defined?(ActiveRecord)
  if Rails.version >= '5.0'
    MigrationBase = ActiveRecord::Migration[5.0]
  else
    MigrationBase = ActiveRecord::Migration
  end
end
