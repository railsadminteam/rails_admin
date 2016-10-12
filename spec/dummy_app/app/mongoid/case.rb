class Case
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  belongs_to :test
end
