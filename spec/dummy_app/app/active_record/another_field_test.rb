class AnotherFieldTest < ActiveRecord::Base
  has_many :nested_field_tests, inverse_of: :another_field_test
end
