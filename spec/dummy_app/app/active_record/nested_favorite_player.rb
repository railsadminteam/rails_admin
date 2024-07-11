

if defined?(CompositePrimaryKeys)
  class NestedFavoritePlayer < FavoritePlayer
    accepts_nested_attributes_for :fanship
  end
end
