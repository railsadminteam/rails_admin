require 'rails_admin/adapters/neo4j'

Paperclip.logger = Logger.new(nil)
DatabaseCleaner.strategy = :transaction

DatabaseCleaner::Neo4j::Base.module_eval do
  def session
    @session ||= ::Neo4j::ActiveBase.current_session
  end
end

DatabaseCleaner::Neo4j::Transaction.class_eval do
  def start
    super
    rollback
    self.tx = ::Neo4j::Transaction.new(session)
  end
end

DatabaseCleaner::Neo4j::Deletion.class_eval do
  def clean
    ::Neo4j::Transaction.run(session) do
      session.query('MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r')
    end
  end
end

class Tableless
  include Neo4j::ActiveNode

  class <<self
    def column(name, sql_type = 'string', default = nil, _null = true)
      # ignore length
      sql_type = sql_type.to_s.sub(/\(.*\)/, '').to_sym
      property(name, type: {integer: Integer, string: String, text: String, date: Date, datetime: DateTime}[sql_type], default: default)
    end
  end
end
