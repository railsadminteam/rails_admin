### Example authorizations for cancan:

```ruby
  # with
  alias_action :update, :destroy, :create, :to => :write

  can :manage, :all
  # includes
  can :write, :all
  # includes
  can :write, Model
  # includes
  can :destroy, Model
  # includes
  can :destroy, Model, { conditions }
  # equals
  can :delete, Model, { conditions }
```

[More here](../lib/rails_admin/config/actions/delete.rb)
