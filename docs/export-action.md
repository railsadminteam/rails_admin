### Example authorizations for cancan:

```ruby
  can :manage, :all
  # includes
  can :export, :all
  # includes
  can :export, Model
  # includes
  can :export, Model, { conditions }
```

[More here](../lib/rails_admin/config/actions/export.rb)
