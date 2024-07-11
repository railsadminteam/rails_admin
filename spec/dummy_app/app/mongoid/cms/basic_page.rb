

module Cms
  class BasicPage
    include Mongoid::Document
    field :title, type: String
    field :content, type: String
    include Mongoid::Timestamps

    validates :title, :content, presence: true
  end
end
