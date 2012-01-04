Devise is installed by default.

If needed, you can tweak the authentification hooks it in your `rails_admin.rb` initializer:

Example for Warden with an 'admin' scope:

```ruby
config.authenticate_with do
  warden.authenticate! :scope => :admin
end
config.current_user_method { current_admin } # hook to your 'current_user' method
```