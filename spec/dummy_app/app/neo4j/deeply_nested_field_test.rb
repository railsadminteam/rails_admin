class DeeplyNestedFieldTest
  include Neo4j::ActiveNode

  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  property :title, type: String
  has_one :out, :nested_field_test, type: :HAS_NESTED_FIELD_TEST
end
