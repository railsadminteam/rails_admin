module Cms
  class BasicPage < ActiveRecord::Base
    set_table_name :cms_basic_pages

    validates :title, :content, :presence => true
  end
end
