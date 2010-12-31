module RailsAdmin
  module Config
    module Fields
      module Types
        class Binary < RailsAdmin::Config::Fields::Types::Boolean
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types::register(self)

          @column_width = 60

          register_instance_option(:partial) do
            "boolean"
          end
        end
      end
    end
  end
end
