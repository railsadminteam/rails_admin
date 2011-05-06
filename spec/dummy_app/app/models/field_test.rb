class FieldTest < ActiveRecord::Base
  has_one :comment, :as => :commentable
end
