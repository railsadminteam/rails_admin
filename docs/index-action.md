### Example authorizations for CanCanCan:

```ruby
  can :manage, :all
  # includes
  can :read, :all
  # includes
  can :read, Model
  # includes
  can :index, Model
  # includes
  can :index, Model, { conditions }
```

[More here](../lib/rails_admin/config/actions/index.rb)
