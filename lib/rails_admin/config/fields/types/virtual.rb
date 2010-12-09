require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        # Virtual field class provides behaviour for columns that are
        # calculated at runtime for example record object methods.
        class Virtual < RailsAdmin::Config::Fields::Base
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          register_instance_option(:column_css_class) do
            "smallString"
          end

          register_instance_option(:column_width) do
            180
          end

          register_instance_option(:formatted_value) do
            unless (output = value).nil?
              output
            else
              "".html_safe
            end
          end

          # Accessor for field's label.
          register_instance_option(:label) do
            name.to_s.underscore.gsub('_', ' ').capitalize
          end

          # Accessor for field's maximum length.
          register_instance_option(:length) do
            100
          end

          # Reader for whether this is field is mandatory.
          register_instance_option(:required?) do
            false
          end

          # Accessor for whether this is field is searchable.
          register_instance_option(:searchable?) do
            false
          end

          # Reader for whether this is a serial field (aka. primary key, identifier).
          register_instance_option(:serial?) do
            false
          end

          # Accessor for whether this is field is sortable.
          register_instance_option(:sortable?) do
            false
          end

          # Reader for field's value
          def value
            bindings[:object].send(name)
          end
        end
      end
    end
  end
end