module RailsAdmin
  module Config
    module Fields
      module Types
        class Redactor < RailsAdmin::Config::Fields::Types::Text
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :options do
            nil
          end

          register_instance_option :css_location do
            ActionController::Base.helpers.asset_path('redactor.css')
          end

          register_instance_option :js_location do
            ActionController::Base.helpers.asset_path('redactor.js')
          end

          register_instance_option :partial do
            :form_redactor
          end

        end
      end
    end
  end
end