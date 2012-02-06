[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/dashboard.rb]]

### Example authorization for cancan:

```ruby
  can :manage, :all
  # includes
  can :dashboard
```