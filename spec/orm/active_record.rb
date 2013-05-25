require 'rails_admin/extensions/history/history'
require 'rails_admin/adapters/active_record'

DatabaseCleaner.strategy = :transaction

ActiveRecord::Base.connection.tables.each do |table|
  ActiveRecord::Base.connection.drop_table(table)
end

silence_stream(STDOUT) do
  ActiveRecord::Migrator.migrate File.expand_path('../../dummy_app/db/migrate/', __FILE__)
end

class Tableless < ActiveRecord::Base
  class <<self
    def columns
      @columns ||= [];
    end

    def column(name, sql_type = nil, default = nil, null = true)
      columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default,
                                                              sql_type.to_s, null)
    end

    def columns_hash
      @columns_hash ||= Hash[columns.map { |column| [column.name, column] }]
    end

    def column_names
      @column_names ||= columns.map { |column| column.name }
    end

    def column_defaults
      @column_defaults ||= columns.map { |column| [column.name, nil] }.inject({}) { |m, e| m[e[0]] = e[1]; m }
    end
  end

  # Override the save method to prevent exceptions.
  def save(validate = true)
    validate ? valid? : true
  end
end
