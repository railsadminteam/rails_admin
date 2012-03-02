require 'builder'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Boolean < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)
          
          register_instance_option :view_helper do
            :check_box
          end

          register_instance_option(:formatted_value) do
            bindings[:view].image_tag("rails_admin/#{value ? 'bullet_black' : 'bullet_white'}.png", :alt => value.to_s)
          end

          register_instance_option(:export_value) do
            value.to_s
          end

          # Accessor for field's help text displayed below input field.
          register_instance_option(:help) do
            ""
          end
        end
      end
    end
  end
end
