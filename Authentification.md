Devise is installed by default.

If needed, you can tweak the authentification hooks it in your `rails_admin.rb` initializer:

```ruby

config.current_user_method { current_user } # hook to your 'current_user' method
```