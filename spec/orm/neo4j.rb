require 'rails_admin/adapters/neo4j'

Paperclip.logger = Logger.new(nil)
DatabaseCleaner.strategy = :transaction


class Tableless
  include Neo4j::ActiveNode

  class <<self
    def column(name, sql_type = 'string', default = nil, _null = true)
      # ignore length
      sql_type = sql_type.to_s.sub(/\(.*\)/, '').to_sym
      field(name, type: {integer: Integer, string: String, text: String, date: Date, datetime: DateTime}[sql_type], default: default)
    end
  end
end
