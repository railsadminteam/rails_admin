Before 01/17/2012, actions used to be standard and hard-coded. A community request was that they could be added/removed/customized.

This is now fully possible.

By default, to keep existing installation safe, all actions are added as they used to be. 

Default is equivalent to:

```ruby
# config/initilizers/rails_admin.rb
RailsAdmin.config do |config|
  config.actions do
    dashboard
    index
    show
    new
    edit
    export
    delete
    bulk_delete
    history_show
    history_index
    show_in_app
  end
end
```

You can copy that block and remove/add any action (1), or pass a block to customize it.
See specific action documentation for details.

(1) do not remove dashboard, index & show, they are needed.