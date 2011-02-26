module RailsAdmin
  module AuthorizationAdapters
    class CanCanAdapter
      def initialize(controller)
        @controller = controller
        @controller.extend ControllerExtension
        @controller.current_ability.authorize! :access, :rails_admin
      end

      def authorize(action, abstract_model = nil, model_object = nil)
        action = translate_action(action)
        @controller.current_ability.authorize!(action, model_object || abstract_model.model) if action
      end

      def authorized?(action, abstract_model = nil, model_object = nil)
        action = translate_action(action)
        @controller.current_ability.can?(action, model_object || abstract_model.model) if action
      end

      def query(action, abstract_model)
        action = translate_action(action)
        abstract_model.model.accessible_by(@controller.current_ability, action)
      end

      def attributes_for(action, abstract_model)
        action = translate_action(action)
        @controller.current_ability.attributes_for(action, abstract_model.model)
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
