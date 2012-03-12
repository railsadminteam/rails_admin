class Tag
  include Mongoid::Document

  field :name, :type => String

  references_and_referenced_in_many :articles
end
