RailsAdmin doesn't need authentication to function, though other dependencies (PaperTrail, History, Cancan..) might need it.

It is perfectly legal to do:

```ruby
# config/initializers/rails_admin.rb
config.authenticate_with {}
config.current_user_method {}
```
