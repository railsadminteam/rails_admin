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
  can :update, Model
  # includes
  can :update, Model, { conditions_and_default_attributes }
```

[More here](../lib/rails_admin/config/actions/edit.rb)
