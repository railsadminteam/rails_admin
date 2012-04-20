module Cms
  class BasicPage < ActiveRecord::Base
    self.table_name = :cms_basic_pages

    attr_accessible :title, :content

    validates :title, :content, :presence => true
  end
end
