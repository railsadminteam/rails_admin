require 'rails_admin/config/base'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the navigation view
      class Export < RailsAdmin::Config::Base
        include RailsAdmin::Config::HasFields

        def initialize(parent)
          super(parent)
          @fields = RailsAdmin::Config::Fields.factory(self)
        end
      end
    end
  end
end
