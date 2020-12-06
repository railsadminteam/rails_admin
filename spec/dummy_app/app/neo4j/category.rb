class Category
  include Neo4j::ActiveNode
Neo4j::ActiveNode

  belongs_to :parent_category, class_name: 'Category'
end
