require 'rails_admin/config/proxyable'
require 'rails_admin/config/configurable'
require 'rails_admin/config/has_fields'
require 'rails_admin/config/has_groups'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the show view for a new object
      class Base
        include RailsAdmin::Config::Proxyable
        include RailsAdmin::Config::Configurable

        include RailsAdmin::Config::HasFields
        include RailsAdmin::Config::HasGroups

        attr_reader :abstract_model
        attr_reader :parent, :root

        def initialize(parent)
          @parent = parent
          @root = parent.root

          @abstract_model = root.abstract_model
        end
      end
    end
  end
end
