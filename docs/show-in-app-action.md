### Example authorizations for cancan:

```ruby
  can :manage, :all
  # includes
  can :show_in_app, :all
  # includes
  can :show_in_app, Model
  # includes
  can :show_in_app, Model, { conditions }
```

[More here](../lib/rails_admin/config/actions/show_in_app.rb)
