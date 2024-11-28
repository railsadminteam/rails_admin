# frozen_string_literal: true

class DeeplyNestedFieldTest < ActiveRecord::Base
  belongs_to :nested_field_test, inverse_of: :deeply_nested_field_tests
end
