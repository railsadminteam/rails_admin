class Article
  include Mongoid::Document

  field :title, :type => String
  field :body,  :type => String

  referenced_in :author
  references_and_referenced_in_many :tags

  embeds_many :notes
  accepts_nested_attributes_for :notes, :allow_destroy => true
end
