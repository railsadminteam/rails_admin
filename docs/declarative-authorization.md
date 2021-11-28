# Declarative authorization

[Declarative Authorization](https://github.com/stffn/declarative_authorization) is not fully integrated into Rails Admin, so it is only possible to add permissions to the controller actions. Currently if you want more integrated authorization, consider [CanCan](cancan.md).

You can hook declarative_authorization into Rails Admin using code like this in an initializer (e.g., config/initializers/rails_admin.rb):

```ruby
require "rails_admin/application_controller"

module RailsAdmin
  class ApplicationController < ::ApplicationController
    filter_access_to :all
  end
end
```

By default, access to the controllers will be denied to all users, so
you need to write some authz rules so that the appropriate users can
get access. These rules will vary, but here's an example:

```ruby
authorization do
  role :admin do
    has_permission_on :rails_admin_history, :to => [:list, :slider, :for_model, :for_object]
    has_permission_on :rails_admin_main, :to => [:index, :show, :new, :edit, :create, :update, :destroy, :list, :delete, :bulk_delete, :bulk_destroy, :get_pages, :show_history]
  end
end
```

This will allow the :admin role to do everything, and will prevent all
other roles from doing anything.

# Authorization Adapter

If you would like better support for Declarative Authorization in Rails Admin, consider making an authorization adapter for it. See the [CanCanCan Adapter](../lib/rails_admin/extensions/cancancan/authorization_adapter.rb) for an example. Fork the project, add the adapter, and send a pull request.
