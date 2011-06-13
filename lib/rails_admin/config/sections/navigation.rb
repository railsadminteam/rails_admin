require 'rails_admin/config/base'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the navigation view
      class Navigation < RailsAdmin::Config::Base
        # Defines the number of tabs to be renderer in the main navigation.
        # Rest of the links will be rendered to a drop down menu.
        register_class_option(:max_visible_tabs) do
          5
        end
      end
    end
  end
end
