module RailsAdmin
  module Extensions
    module CanCanCan
      # This adapter is for the CanCanCan[https://github.com/CanCanCommunity/cancancan] authorization library.
      class AuthorizationAdapter < RailsAdmin::Extensions::CanCan::AuthorizationAdapter
        def authorize(action, abstract_model = nil, model_object = nil)
          return unless action
          subject = model_object || abstract_model && abstract_model.model
          if authorized_for_dashboard_in_legacy_way?(action)
            subject
          else
            @controller.current_ability.authorize!(*resolve_with_compatibility(action, subject))
          end
        end

        def authorized?(action, abstract_model = nil, model_object = nil)
          return unless action
          subject = model_object || abstract_model && abstract_model.model
          authorized_for_dashboard_in_legacy_way?(action, true) ||
            @controller.current_ability.can?(*resolve_with_compatibility(action, subject))
        end

      private

        def authorized_for_dashboard_in_legacy_way?(action, silent = false)
          return false unless action == :dashboard
          legacy_ability = @controller.current_ability.permissions[:can][:dashboard]
          if legacy_ability && (legacy_ability.empty? || legacy_ability.all?(&:empty?))
            ActiveSupport::Deprecation.warn('RailsAdmin CanCanCan Ability with `can :dashboard` is old and support will be removed in the next major release, use `can :read, :dashboard` instead. See https://github.com/sferik/rails_admin/issues/2901') unless silent
            true
          else
            false
          end
        end

        def resolve_with_compatibility(action, subject)
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
