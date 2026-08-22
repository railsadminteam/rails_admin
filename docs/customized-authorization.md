You have access to the controller though `self` or with a block variable. You can decide whether the user should or should not be allowed to continue with something like:

```ruby
# in config/initializer/rails_admin.rb

RailsAdmin.config do |config|
  config.authorize_with do |controller|
    redirect_to main_app.root_path unless current_user.try(:admin?)
  end
end
```


NOTE: If you are doing custom authorization or your authorization library's `current_user` method is not available in initializer use this:

```
config.parent_controller = "::ApplicationController"
```

In case that more complex authorization rules need to be applied, like a user profile having limited access to models and actions, a custom extension can be implemented as any of the [already existing extensions](https://github.com/railsadminteam/rails_admin/tree/master/lib/rails_admin/extensions):
```ruby
module RailsAdmin
  module Extensions
    module MyCustomExtension
      class AuthorizationAdapter
        attr_reader :controller

        delegate :_current_user, to: :controller

        SUPPORT_FULL_MODELS = { 'Integration' => { except: %i[edit new export] } }.freeze

        def initialize(controller)
          @controller = controller
        end

        # This method is called in every controller action and should raise an
        # exception when the authorization fails. The first argument is the name
        # of the controller action as a symbol (:create, :bulk_delete, etc.).
        # The second argument is the AbstractModel instance that applies. The
        # third argument is the actual model instance if it is available.
        def authorize(action, abstract_model = nil, model_object = nil)
          return if authorized?(action, abstract_model, model_object)

          raise ActionController::RoutingError, 'Not Found'
        end

        # This method is called primarily from the view to determine whether the
        # given user has access to perform the action on a given model. It
        # should return true when authorized. This takes the same arguments as
        # +authorize+. The difference is that this will return a boolean whereas
        # +authorize+ will raise an exception when not authorized.
        def authorized?(action, abstract_model = nil, model_object = nil)
          # Devs can access everything
          return true if _current_user.has_access?(:support_dev)

          record = model_object&.model_name&.name || abstract_model&.model_name
          _current_user.has_access?(:support_full) &&
            authorized_for_full_support?(action, record)
        end

        # This is called when needing to scope a database query. It is called
        # within the list and bulk_delete/destroy actions and should return a
        # scope which limits the records to those which the user can perform the
        # given action on.
        def query(_action, abstract_model)
          # No query restrictions for now
          abstract_model.model.all
        end

        # This is called in the new/create actions to determine the initial
        # attributes for new records. It should return a hash of attributes
        # which match what the user is authorized to create.
        def attributes_for(_action, _abstract_model)
          # No attribute restrictions for now
          {}
        end

        private

        def authorized_for_full_support?(action, record)
          !record ||
            SUPPORT_FULL_MODELS[record]&.fetch(:except, [])&.exclude?(action)
        end
      end
    end
  end
end

RailsAdmin.add_extension(:my_custom_extension, RailsAdmin::Extensions::MyCustomExtension, authorization: true)

RailsAdmin.config do |config|
  config.authorize_with :my_custom_extension
end
```