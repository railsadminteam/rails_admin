module RailsAdmin
  module AuthorizationAdapters
    class CanCanAdapter
      def initialize(controller)
        @controller = controller
        @controller.extend ControllerExtension
      end

      def authorize(action, model_class = nil, model_object = nil)
        action = translate_action(action)
        @controller.current_ability.authorize! :access, :rails_admin
        @controller.current_ability.authorize!(action, model_object || model_class) if action
      end

      def query(model_class, action)
        action = translate_action(action)
        model_class.accessible_by(@controller.current_ability, action)
      end

      def attributes_for(action, model_class)
        action = translate_action(action)
        @controller.current_ability.attributes_for(action, model_class)
      end

      private

      # Change the action into something that fits better with CanCan's conventions
      def translate_action(action)
        case action
        when :index then nil # we don't want to do extra action authorization for dashboard
        when :list then :index
        when :delete then :destroy
        else action
        end
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
