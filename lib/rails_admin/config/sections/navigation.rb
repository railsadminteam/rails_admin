require 'rails_admin/config/base'
require 'rails_admin/config/hideable'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the navigation view
      class Navigation < RailsAdmin::Config::Base
        # Defines the number of tabs to be renderer in the main navigation.
        # Rest of the links will be rendered to a drop down menu.
        # NOTE: "max_visible_tabs" is deprecated
        # FIXME: remove this after giving people an appropriate time
        # to change their code.
        register_class_option(:max_visible_tabs) do
          ActiveSupport::Deprecation.warn("Navigation.max_visible_tabs configuration option is deprecated", caller)
          5
        end
      end
    end
  end
end
