class NestedFieldTest < ActiveRecord::Base
  attr_accessible :title, :field_test_id, :another_field_test_id, :comment_attributes

  belongs_to :field_test, :inverse_of => :nested_field_tests
  belongs_to :another_field_test, :inverse_of => :nested_field_tests
  has_one :comment, :as => :commentable
  accepts_nested_attributes_for :comment, :allow_destroy => true, :reject_if => proc { |attributes| attributes["content"].blank? }
end
