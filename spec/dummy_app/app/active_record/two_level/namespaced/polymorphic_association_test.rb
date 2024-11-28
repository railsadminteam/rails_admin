# frozen_string_literal: true

module TwoLevel
  module Namespaced
    class PolymorphicAssociationTest < ActiveRecord::Base
      has_many :comments, as: :commentable
    end
  end
end
