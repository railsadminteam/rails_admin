# frozen_string_literal: true

if ActiveRecord.gem_version >= Gem::Version.new('7.1') || defined?(CompositePrimaryKeys)
  class NestedFan < Fan
    accepts_nested_attributes_for :fanships
    accepts_nested_attributes_for :fanship
  end
end
