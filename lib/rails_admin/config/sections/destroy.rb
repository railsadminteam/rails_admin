require 'rails_admin/config/base'

module RailsAdmin
  module Config
    module Sections
      # Configuration of the destroy view
      class Destroy < RailsAdmin::Config::Base

        # Defines if the objects will be destroyed using a custom_method
        register_instance_option(:soft_destroy) do
          false
        end
        # Defines if we should display the related objects on delete
        register_instance_option(:related) do
          true
        end
      end
    end
  end
end
