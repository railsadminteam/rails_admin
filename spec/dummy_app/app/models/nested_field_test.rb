class NestedFieldTest < ActiveRecord::Base
  belongs_to :field_test, :inverse_of => :nested_field_tests
end
