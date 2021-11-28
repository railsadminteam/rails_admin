# Authorization

Authorization can be added using the `authorize_with` method. If you pass a block
it will be triggered through a `before_action` on every action in Rails Admin.

For example:

```ruby
RailsAdmin.config do |config|
  config.authorize_with do
    redirect_to main_app.root_path unless current_user.is_admin?
  end
end
```

To use an authorization adapter, pass the name of the adapter. For example, to use
with [CanCanCan](https://github.com/CanCanCommunity/cancancan), pass it like this.

```ruby
RailsAdmin.config do |config|
  config.authorize_with :cancancan
end
```

Also, there's built-in support for Pundit:

```ruby
RailsAdmin.config do |config|
  config.authorize_with :pundit
end
```

- [CanCanCan (recommended)](cancancan.md)
- [CanCan with relation to current Model](cancan-remove-associated-action-buttons-in-forms.md)
- [Declarative Authorization (possible)](declarative-authorization.md)
- [Manually](customized-authorization.md)
