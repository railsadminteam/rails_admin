class NestedFieldTest < ActiveRecord::Base
  belongs_to :field_test, :inverse_of => :nested_field_tests
  accepts_nested_attributes_for :field_test, :allow_destroy => true
end
