Rails Admin is fully compatible with [[CanCan|https://github.com/ryanb/cancan]], an authorization framework to limit which actions a user can perform on each model.

### Setup CanCan

If you haven't already, setup CanCan by adding it to your Gemfile and running the `bundle` command.

```ruby
gem "cancan"
```

Next, run the generator to create an Ability class. This is where authorization rules are defined.

```bash
rails g cancan:ability
```

### Add to Rails Admin

To use it with Rails Admin, add this to an initializer.

```ruby
# in config/initializers/rails_admin.rb

RailsAdmin.config do |config|
  config.authorize_with :cancan
end
```

At this point, all authorization will fail and no one will be able to access the admin pages. To grant access, add this to `Ability#initialize`.

```ruby
can :access, :rails_admin
```

Then, you will need to grant access on each of the models. Here's a complete example of an `Ability` class which defines different permissions depending upon the user's role.

```ruby
class Ability
  include CanCan::Ability
  def initialize(user)
    can :read, :all                   # allow everyone to read everything
    if user && user.admin?
      can :access, :rails_admin       # only allow admin users to access Rails Admin
      if user.role? :superadmin
        can :manage, :all             # allow superadmins to do anything
      elsif user.role? :manager
        can :manage, [User, Product]  # allow managers to do anything to products and users
      elsif user.role? :sales
        can :update, Product, :hidden => false  # allow sales to only update visible products
      end
    end
  end
end
```

How you define the user roles is completely up to you. See the [[CanCan Documentation|https://github.com/ryanb/cancan/wiki]] for more information.

### Handle Unauthorized Access

If the user authorization fails, a CanCan::AccessDenied exception will be raised. You can catch this and modify its behavior in the ApplicationController.

```ruby
class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_path, :alert => exception.message
  end
end
```

### CanCan::AuthorizationNotPerformed exception

remove `check_authorization` from app/controllers/application_controller.rb, use `load_and_authorize_resource` on every controllers instead. 

### Role tree

Use :manage if you need user to have access to all actions on a model. 

RailsAdmin use 2 customs verbs: :history & :show_in_app
They get overridden by :manage in Cancan.