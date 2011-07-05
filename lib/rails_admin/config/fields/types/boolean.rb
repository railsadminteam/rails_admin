require 'builder'

module RailsAdmin
  module Config
    module Fields
      module Types
        class Boolean < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @view_helper = :check_box

          register_instance_option(:formatted_value) do
            if value == true
              Builder::XmlMarkup.new.img(:src => bindings[:view].image_path("rails_admin/bullet_black.png"), :alt => "True").html_safe
            else
              Builder::XmlMarkup.new.img(:src => bindings[:view].image_path("rails_admin/bullet_white.png"), :alt => "False").html_safe
            end
          end

          # Accessor for field's help text displayed below input field.
          register_instance_option(:help) do
            ""
          end

          register_instance_option(:html_attributes) do
            {
              :class => "#{css_class} #{has_errors? ? "errorField" : nil}",
              :checked => (value && value.to_s != "0"),
              :style => "width:#{column_width}px",
            }
          end
        end
      end
    end
  end
end
