class NestedFieldTest
  include Neo4j::ActiveNode

  property :title, type: String
  has_one :out, :field_test, type: :HAS_NESTED_FIELD_TEST
  has_one :out, :another_field_test, type: :HAS_ANOTHER_FIELD_TEST

  property :created_at, type: DateTime
  property :updated_at, type: DateTime

  has_many :in, :deeply_nested_field_tests, origin: :nested_field_test
  #accepts_nested_attributes_for :deeply_nested_field_tests, allow_destroy: true
  #has_one :comment, as: :commentable, autosave: true
  #accepts_nested_attributes_for :comment, allow_destroy: true, reject_if: proc { |attributes| attributes['content'].blank? }
end
