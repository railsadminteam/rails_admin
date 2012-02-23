class Author
  include Mongoid::Document

  field :name, :type => String
  references_many :articles
end
