

class Embed
  include Mongoid::Document
  field :name, type: String

  embedded_in :field_test
end
