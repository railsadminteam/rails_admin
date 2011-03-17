require 'rails_admin/config/base'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the navigation view
      class Navigation < RailsAdmin::Config::Base
        include RailsAdmin::Config::Hideable

        # Defines the number of tabs to be renderer in the main navigation.
        # Rest of the links will be rendered to a drop down menu.
        register_class_option(:max_visible_tabs) do
          5
        end

        # Get all models that are configured as visible sorted by their label.
        #
        # @see RailsAdmin::Config::Hideable
        def self.visible_models
          RailsAdmin::Config.models.select {|m| m.navigation.visible? }.sort do |a, b|
            a.label.downcase <=> b.label.downcase
          end
        end
      end
    end
  end
end