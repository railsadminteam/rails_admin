History is RailsAdmin's historic change observer.

It used to be activated by default, not anymore.

Activate it with:

```ruby
config.audit_with :history, User
```

User should be your 'user' model.