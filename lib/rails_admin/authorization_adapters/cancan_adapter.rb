module RailsAdmin
  module AuthorizationAdapters
    class CanCanAdapter
      def initialize(controller)
        @controller = controller
        @controller.extend ControllerExtension
      end

      def authorize(action, model_class, model_object = nil)
        @controller.current_ability.authorize!(action, model_object || model_class)
      end

      def query(model_class, action)
        model_class.accessible_by(@controller.current_ability, action)
      end

      def attributes_for(action, model_class)
        @controller.current_ability.attributes_for(action, model_class)
      end

      module ControllerExtension
        def current_ability
          # use _current_user instead of default current_user so it works with
          # whatever current user method is defined with RailsAdmin
          @current_ability ||= ::Ability.new(_current_user)
        end
      end
    end
  end
end
