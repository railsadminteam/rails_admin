if defined?(ActiveRecord)
  MigrationBase = # rubocop:disable ConstantName
    if Rails.version >= '5.0'
      ActiveRecord::Migration[5.0]
    else
      ActiveRecord::Migration
    end
end
