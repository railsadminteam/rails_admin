class Category
  include Neo4j::ActiveNode

  has_one :out, :parent_category, type: :parent, model_class: :Category
end
