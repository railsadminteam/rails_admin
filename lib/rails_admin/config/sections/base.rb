require 'rails_admin/config/proxyable'
require 'rails_admin/config/configurable'
require 'rails_admin/config/has_fields'
require 'rails_admin/config/has_groups'
require 'rails_admin/config/has_description'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the show view for a new object
      class Base
        include RailsAdmin::Config::Proxyable
        include RailsAdmin::Config::Configurable

        include RailsAdmin::Config::HasFields
        include RailsAdmin::Config::HasGroups
        include RailsAdmin::Config::HasDescription

        attr_reader :abstract_model
        attr_reader :parent, :root

        def initialize(parent)
          @parent = parent
          @root = parent.root

          @abstract_model = root.abstract_model
        end

        def inspect
          "#<#{self.class.name} #{
            instance_variables.collect do |v|
              value = instance_variable_get(v)
              if [:@parent, :@root, :@abstract_model].include? v
                if value.respond_to? :name
                  "#{v}=#{value.name.inspect}"
                else
                  "#{v}=#{value.class.name}"
                end
              else
                "#{v}=#{value.inspect}"
              end
            end.join(', ')
          }>"
        end
      end
    end
  end
end
