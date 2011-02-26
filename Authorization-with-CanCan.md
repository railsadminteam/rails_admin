Rails Admin is fully compatible with [[CanCan|https://github.com/ryanb/cancan]], an authorization framework to limit which actions each user can perform on each model.

First, setup CanCan like normal as described in the [[readme|https://github.com/ryanb/cancan#readme]]. To use it with Rails Admin, add this to an initializer.

```ruby
# in config/initializers/rails_admin.rb
RailsAdmin.authorize_with :cancan
```

Add this line to Ability to define who is allowed to use the admin pages.

```ruby
can :access, :rails_admin
```

You can then add further permissions on each resource. Here's a full example Ability class.

```ruby
class Ability
  include CanCan::Ability
  def initialize(user)
    can :read, :all                   # allow everyone to read everything
    if user
      can :access, :rails_admin    # only allow logged in user access to Rails Admin
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

How you define the user roles is completely up to you. See the [[CanCan Documentation|https://github.com/ryanb/cancan/wiki]] if you aren't familiar with it already.