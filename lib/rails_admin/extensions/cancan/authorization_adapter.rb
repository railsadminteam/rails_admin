module RailsAdmin
  module Extensions
    module CanCan
      # This adapter is for the CanCan[https://github.com/ryanb/cancan] authorization library.
      # You can create another adapter for different authorization behavior, just be certain it
      # responds to each of the public methods here.
      class AuthorizationAdapter
        # See the +authorize_with+ config method for where the initialization happens.
        def initialize(controller, ability = ::Ability)
          @controller = controller
          @controller.instance_variable_set '@ability', ability
          @controller.extend ControllerExtension
          @controller.current_ability.authorize! :access, :rails_admin
        end

        # This method is called in every controller action and should raise an exception
        # when the authorization fails. The first argument is the name of the controller
        # action as a symbol (:create, :bulk_delete, etc.). The second argument is the
        # AbstractModel instance that applies. The third argument is the actual model
        # instance if it is available.
        def authorize(action, abstract_model = nil, model_object = nil)
          @controller.current_ability.authorize!(action, model_object || abstract_model && abstract_model.model) if action
        end

        # This method is called primarily from the view to determine whether the given user
        # has access to perform the action on a given model. It should return true when authorized.
        # This takes the same arguments as +authorize+. The difference is that this will
        # return a boolean whereas +authorize+ will raise an exception when not authorized.
        def authorized?(action, abstract_model = nil, model_object = nil)
          @controller.current_ability.can?(action, model_object || abstract_model && abstract_model.model) if action
        end

        # This is called when needing to scope a database query. It is called within the list
        # and bulk_delete/destroy actions and should return a scope which limits the records
        # to those which the user can perform the given action on.
        def query(action, abstract_model)
          abstract_model.model.accessible_by(@controller.current_ability, action)
        end

        # This is called in the new/create actions to determine the initial attributes for new
        # records. It should return a hash of attributes which match what the user
        # is authorized to create.
        def attributes_for(action, abstract_model)
          @controller.current_ability.attributes_for(action, abstract_model && abstract_model.model)
        end

        module ControllerExtension
          def current_ability
            # use _current_user instead of default current_user so it works with
            # whatever current user method is defined with RailsAdmin
            @current_ability ||= @ability.new(_current_user)
          end
        end
      end
    end
  end
end
