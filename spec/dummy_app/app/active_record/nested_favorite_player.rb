# frozen_string_literal: true

if ActiveRecord.gem_version >= Gem::Version.new('7.1') || defined?(CompositePrimaryKeys)
  class NestedFavoritePlayer < FavoritePlayer
    accepts_nested_attributes_for :fanship
  end
end
