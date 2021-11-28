### Example authorizations for cancan:

```ruby
  # with
  alias_action :update, :destroy, :create, :to => :write

  can :manage, :all
  # includes
  can :write, :all
  # includes
  can :destroy, Model
  # equals
  can :delete, Model
  # includes
  can :destroy, Model, { conditions }
```

[More here](../lib/rails_admin/config/actions/bulk_delete.rb)
