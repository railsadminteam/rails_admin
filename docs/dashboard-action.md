### Example authorizations for cancan:

```ruby
  can :manage, :all
  # includes
  can :dashboard
```

### Disabling record count bars:

You can hide dashboard statistics graphs via the [actions](actions.md) configuration. This is useful when working with huge datasets that take a long time to be queried.

Note that once you start configuring actions, it will only load the ones you specify, so if you want to disable statistics while keeping everything else at the default setting, then you need to include all the actions, like so:

```ruby
RailsAdmin.config do |c|
  c.actions do
    dashboard do
      statistics false
    end
    # collection actions
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    # member actions
    show
    edit
    delete
    history_show
    show_in_app
  end
end
```

Note that disabling statistics removes the entire dashboard table, not just the colored graphs.

[More here](../lib/rails_admin/config/actions/dashboard.rb)
