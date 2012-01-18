class Category < ActiveRecord::Base
  belongs_to :parent_category, :class_name => "Category"
end
