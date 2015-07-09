class Embed
  include Neo4j::ActiveNode
Neo4j::ActiveNode
  property :name, type: String

  embedded_in :field_test
end
