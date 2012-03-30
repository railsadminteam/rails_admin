class UnscopedPage
  include Mongoid::Document
  field :title, :type => String
  include Mongoid::Timestamps
end
