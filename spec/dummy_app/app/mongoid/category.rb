

class Category
  include Mongoid::Document

  belongs_to :parent_category, class_name: 'Category'
end
