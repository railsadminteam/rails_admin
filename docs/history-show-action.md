### Example authorizations for cancan:

```ruby
  can :manage, :all
  # includes
  can :history, :all
  # includes
  can :history, Model
  # includes
  can :history, Model, { conditions }
```

[More here](https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/history_show.rb)
