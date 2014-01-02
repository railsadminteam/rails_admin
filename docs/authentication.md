You can (each is optional) provide 2 things:

1. An `authenticate_with` block that will trigger your authentication logic before any action in RailsAdmin.
2. A `current_user_method` block that will yield a user model (for UI purposes)

```ruby
RailsAdmin.config do |config|
  config.authenticate_with { warden.authenticate! scope: :user }
  config.current_user_method &:current_user
end
```