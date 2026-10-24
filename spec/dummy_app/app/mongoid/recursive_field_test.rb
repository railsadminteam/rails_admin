# frozen_string_literal: true

# A nested form that can reach itself; Category is the ActiveRecord counterpart.
class RecursiveFieldTest
  include Mongoid::Document
  field :title, type: String
  recursively_embeds_many
  accepts_nested_attributes_for :child_recursive_field_tests, allow_destroy: true
end
