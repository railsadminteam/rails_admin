# frozen_string_literal: true

class Comment
  include Mongoid::Document
  field :content, type: String
  field :boolean_field, type: Mongoid::Boolean
  include Mongoid::Timestamps
  include Taggable

  belongs_to :commentable, polymorphic: true
end
