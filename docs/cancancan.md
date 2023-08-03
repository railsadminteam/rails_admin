# CanCanCan

Rails Admin is fully compatible with [CanCanCan](https://github.com/CanCanCommunity/cancancan).

### Configuration

Add this to RailsAdmin initializer.

```ruby
# config/initializers/rails_admin.rb

RailsAdmin.config do |config|
  config.authorize_with :cancancan
end
```

At this point, all authorization will fail and no one will be able to access the admin pages. To grant access, add this to `Ability#initialize`.
You must also grant access to the `dashboard`, or the login will fail there.

```ruby
can :access, :rails_admin   # grant access to rails_admin
can :read, :dashboard       # grant access to the dashboard
```

Then, you will need to grant access on each of the models. Here's a complete example of an `Ability` class which defines different permissions depending upon the user's role.

```ruby
class Ability
  include CanCan::Ability
  def initialize(user)
    can :read, :all                 # allow everyone to read everything
    return unless user && user.admin?
    can :access, :rails_admin       # only allow admin users to access Rails Admin
    can :read, :dashboard           # allow access to dashboard
    if user.role? :superadmin
      can :manage, :all             # allow superadmins to do anything
    elsif user.role? :manager
      can :manage, [User, Product]  # allow managers to do anything to products and users
    elsif user.role? :sales
      can :update, Product, hidden: false  # allow sales to only update visible products
    end
  end
end
```

How you define the user roles is completely up to you. See the [CanCanCan Documentation](https://github.com/CanCanCommunity/cancancan/wiki) for more information.

### Use different Ability classes for front-end and admin

If you use CanCanCan in your project, there are chances that abilities for RailsAdmin will conflict with your project ones. In that case, you will want to define a specific Ability class for admin section (e.g. `AdminAbility`).

You just have to add your admin ability class as a second parameter to `authorize_with`:

```ruby
# in config/initializers/rails_admin.rb

RailsAdmin.config do |config|
  config.authorize_with :cancancan, AdminAbility
end
```

With `AdminAbility`:

```ruby
# in models/admin_ability.rb
class AdminAbility
  include CanCan::Ability
  def initialize(user)
    return unless user && user.admin?
    can :access, :rails_admin
    can :manage, :all
  end
end
```

### Handle Unauthorized Access

If the user authorization fails, a CanCan::AccessDenied exception will be raised. You can catch this and modify its behavior in the ApplicationController.

```ruby
class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, alert: exception.message
  end
end
```

Also make sure RailsAdmin is inheriting from ApplicationController:

```ruby
# in config/initializers/rails_admin.rb

config.parent_controller = 'ApplicationController'
```

### RailsAdmin verbs

Each action in RailsAdmin checks for authorization if adapter is present.
Usually the name of the action gives the name of the verb used.

Here are the checks used by default in RailsAdmin:

```ruby
# Always performed
can :access, :rails_admin # needed to access RailsAdmin

# Performed checks for `root` level actions:
can :read, :dashboard            # dashboard access

# Performed checks for `collection` scoped actions:
can :index, Model         # included in :read
can :new, Model           # included in :create
can :export, Model
can :history, Model       # for HistoryIndex
can :destroy, Model       # for BulkDelete

# Performed checks for `member` scoped actions:
can :show, Model, object            # included in :read
can :edit, Model, object            # included in :update
can :destroy, Model, object         # for Delete
can :history, Model, object         # for HistoryShow
can :show_in_app, Model, object
```
