class Article
  include Mongoid::Document

  field :title, :type => String
  field :body,  :type => String

  referenced_in :author
  references_and_referenced_in_many :tags
end
