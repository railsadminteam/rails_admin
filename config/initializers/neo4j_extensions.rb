if defined?(::Neo4j::ActiveNode)
  require 'rails_admin/adapters/neo4j/extension'
  Neo4j::ActiveNode.send(:include, RailsAdmin::Adapters::Neo4j::Extension)
end

if defined?(::Neo4j::ActiveRel)
  require 'rails_admin/adapters/neo4j/extension'
  Neo4j::ActiveRel.send(:include, RailsAdmin::Adapters::Neo4j::Extension)
end
