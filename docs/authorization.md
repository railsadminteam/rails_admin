Authorization can be added using the `authorize_with` method. If you pass a block
it will be triggered through a before filter on every action in Rails Admin.

```ruby
RailsAdmin.config do |config|
  config.authorize_with do
    redirect_to main_app.root_path unless warden.user.is_admin?
  end
end
```

To use an authorization adapter, pass the name of the adapter. For example, to use
with [CanCan](https://github.com/ryanb/cancan), pass it like this.

```ruby
RailsAdmin.config do |config|
  config.authorize_with :cancan
end
```

* [[CanCan (recommended)|CanCan]]
* [[CanCan with relation to current Model|CanCan:-remove-associated-action-buttons-in-forms]]
* [[Declarative Authorization (possible)|Declarative Authorization]]
* [[Manually|Customized authorization]]
