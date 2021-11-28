### Example authorizations for cancan:

```ruby
  # with
  alias_action :update, :destroy, :create, :to => :write

  can :manage, :all
  # includes
  can :write, :all
  # includes
  can :create, Model
  # equals
  can :new, Model
  # includes
  can :create, Model, { default_attributes }
```

[More here](../lib/rails_admin/config/actions/new.rb)
