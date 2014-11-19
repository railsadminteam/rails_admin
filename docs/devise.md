Example for Warden/Devise with an 'user' scope:

In `config/initializers/rails_admin.rb`
```ruby
RailsAdmin.config do |config|
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)
end
```

Or for an 'admin' scope:

In `config/initializers/rails_admin.rb`
```ruby
RailsAdmin.config do |config|
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)
end
```

Remember to add the routes for the scope you are working with:
```ruby
devise_for :user
```

Or if you are using on :admin
```ruby
devise_for :admin
```


Currently there is a bug in devise https://github.com/plataformatec/devise/issues/3321
It is recommended to copy the devise view and modify as the issue said.