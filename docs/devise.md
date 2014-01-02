Example for Warden/Devise with an 'user' scope:

In `config/initializers/rails_admin.rb`
```ruby
config.authenticate_with do
  warden.authenticate! :scope => :user
end
config.current_user_method { current_user }
```

Or for an 'admin' scope:

In `config/initializers/rails_admin.rb`
```ruby
config.authenticate_with do
  warden.authenticate! :scope => :admin
end
config.current_user_method { current_admin }
```