require 'rails_admin/config/base'
require 'rails_admin/config/hideable'
require 'rails_admin/config/fields'
require 'rails_admin/config/has_fields'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the navigation view
      class Search < RailsAdmin::Config::Base
        include RailsAdmin::Config::HasFields
        
        def initialize(parent)
          super(parent)
          # Populate @fields instance variable with model's properties
          @fields = RailsAdmin::Config::Fields.factory(self)
        end
      end
    end
  end
end