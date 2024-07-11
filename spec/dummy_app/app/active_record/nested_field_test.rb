

class NestedFieldTest < ActiveRecord::Base
  belongs_to :field_test, optional: true, inverse_of: :nested_field_tests
  belongs_to :another_field_test, optional: true, inverse_of: :nested_field_tests
  has_one :comment, as: :commentable
  has_many :deeply_nested_field_tests, inverse_of: :nested_field_test
  accepts_nested_attributes_for :comment, allow_destroy: true, reject_if: proc { |attributes| attributes['content'].blank? }
  accepts_nested_attributes_for :deeply_nested_field_tests, allow_destroy: true
end
