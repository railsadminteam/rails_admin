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
      @columns ||= []
    end

    def column(name, sql_type = nil, default = nil, null = true)
      columns <<
        if connection.respond_to?(:lookup_cast_type)
          ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, connection.lookup_cast_type(sql_type.to_s), sql_type.to_s, null)
        else
          ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
        end
    end

    def columns_hash
      @columns_hash ||= Hash[columns.collect { |column| [column.name, column] }]
    end

    def column_names
      @column_names ||= columns.collect(&:name)
    end

    def column_defaults
      @column_defaults ||= columns.collect { |column| [column.name, nil] }.each_with_object({}) do |e, a|
        a[e[0]] = e[1]
        a
      end
    end
  end

  # Override the save method to prevent exceptions.
  def save(validate = true)
    validate ? valid? : true
  end
end

##
# Column length detection seems to be broken for PostgreSQL.
# This is a workaround..
# Refs. https://github.com/rails/rails/commit/b404613c977a5cc31c6748723e903fa5a0709c3b
#
if defined?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
  ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
    def lookup_cast_type(sql_type)
      oid = execute("SELECT #{quote(sql_type)}::regtype::oid", 'SCHEMA').first['oid'].to_i
      type_map.lookup(oid, sql_type)
    end
  end
end
