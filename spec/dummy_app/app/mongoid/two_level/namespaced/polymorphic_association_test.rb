

module TwoLevel
  module Namespaced
    class PolymorphicAssociationTest
      include Mongoid::Document

      field :name, type: String

      has_many :comments, as: :commentable
    end
  end
end
