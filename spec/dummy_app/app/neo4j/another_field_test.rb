class AnotherFieldTest
  include Neo4j::ActiveNode

  has_many :in, :nested_field_tests, origin: :another_field_test
end
