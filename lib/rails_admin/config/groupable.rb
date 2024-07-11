

require 'rails_admin/config/fields/group'

module RailsAdmin
  module Config
    module Groupable
      # Register a group instance variable and accessor methods for objects
      # extending the has groups mixin. The extended objects must implement
      # reader for a parent object which includes this module.
      #
      # @see RailsAdmin::Config::HasGroups.group
      # @see RailsAdmin::Config::Fields::Group
      def group(name = nil)
        @group = parent.group(name) unless name.nil? # setter
        @group ||= parent.group(:default) # getter
      end
    end
  end
end
