class Category
  include Mongoid::Document

  attr_accessible :parent_category_id

  belongs_to :parent_category, :class_name => "Category"
end
