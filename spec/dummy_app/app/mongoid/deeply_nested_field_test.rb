

class DeeplyNestedFieldTest
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title, type: String
  belongs_to :nested_field_test, inverse_of: :deeply_nested_field_tests
end
