# frozen_string_literal: true

class Category < ActiveRecord::Base
  belongs_to :parent_category, class_name: 'Category', optional: true, inverse_of: :child_categories
  # A nested form that can reach itself; RecursiveFieldTest is the Mongoid counterpart.
  has_many :child_categories, class_name: 'Category', foreign_key: :parent_category_id,
                              inverse_of: :parent_category
  accepts_nested_attributes_for :child_categories, allow_destroy: true
end
