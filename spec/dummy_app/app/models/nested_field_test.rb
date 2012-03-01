class NestedFieldTest < ActiveRecord::Base
  belongs_to :field_test, :inverse_of => :nested_field_tests

  has_one :comment, :as => :commentable
  accepts_nested_attributes_for :comment, :allow_destroy => true, :reject_if => proc { |attributes| attributes["content"].blank? }
end
