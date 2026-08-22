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

[More here](https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/show_in_app.rb)