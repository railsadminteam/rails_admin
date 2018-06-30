module RailsAdmin
  module Extensions
    module CanCanCan
      # This adapter is for the CanCanCan[https://github.com/CanCanCommunity/cancancan] authorization library.
      class AuthorizationAdapter < RailsAdmin::Extensions::CanCan::AuthorizationAdapter
        def authorize(action, abstract_model = nil, model_object = nil)
          return unless action
          action, subject = resolve_action_and_subject(action, abstract_model, model_object)
          @controller.current_ability.authorize!(action, subject)
        end

        def authorized?(action, abstract_model = nil, model_object = nil)
          return unless action
          action, subject = resolve_action_and_subject(action, abstract_model, model_object)
          @controller.current_ability.can?(action, subject)
        end

      private

        def resolve_action_and_subject(action, abstract_model, model_object)
          subject = model_object || abstract_model && abstract_model.model
          if subject
            [action, subject]
          else
            # For :dashboard compatibility
            [:read, action]
          end
        end
      end
    end
  end
end
