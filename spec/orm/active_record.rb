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
      columns << ActiveRecord::ConnectionAdapters::Column.new(
        name.to_s, default,
        connection.respond_to?(:lookup_cast_type) ? connection.lookup_cast_type(sql_type.to_s) : sql_type.to_s,
        null)
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
