# frozen_string_literal: true

module Cms
  class BasicPage < ActiveRecord::Base
    self.table_name = :cms_basic_pages

    validates :title, :content, presence: true
  end
end
