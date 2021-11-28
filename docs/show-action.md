### Example authorizations for cancan:

```ruby
  can :manage, :all
  # includes
  can :read, :all
  # includes
  can :read, Model
  # includes
  can :show, Model
  # includes
  can :show, Model, { conditions }
```

[More here](../lib/rails_admin/config/actions/show.rb)
