require 'rails_admin/config/base'
require 'rails_admin/config/has_fields'
require 'rails_admin/config/has_groups'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the show view for a new object
      class Base < RailsAdmin::Config::Base
        include RailsAdmin::Config::HasFields
        include RailsAdmin::Config::HasGroups
        
        def initialize(parent)
          super(parent)
        end
      end
    end
  end
end
