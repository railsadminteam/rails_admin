module Cms
  class BasicPage < ActiveRecord::Base
    validates :title, :content, :presence => true
  end
end