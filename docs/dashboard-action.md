### Example authorizations for cancan:

```ruby
  can :manage, :all
  # includes
  can :dashboard
```

### Disabling record count bars:

You can hide dashboard statistics graphs by the action configuration.
This is useful on working with huge dataset which take much time to be queried upon.

```ruby
RailsAdmin.config do |c|
  c.actions do
    dashboard do
      statistics false
    end
  end
end
```

[[More here|https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/dashboard.rb]]