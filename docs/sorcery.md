# Sorcery

Here are listed community proposed solutions to solve [Sorcery](https://github.com/Sorcery/sorcery) and RailsAdmin compatibility:

### Authentication

This was proposed by David Tuite on [SO](http://stackoverflow.com/questions/9815062/rails-admin-with-sorcery/9834837)

Authentication with Sorcery requires manual tweaking of `rails_admin.rb` initializer.

```ruby
RailsAdmin.config do |config|
  config.authenticate_with do
    # Use sorcery's before filter to auth users
    require_login
  end
  config.current_user_method(&:current_user)
end

```

You will also need to update the `not_authenticated` in your `application_controller.rb`:

```ruby
class ApplicationController
  # Overwrite the method sorcery calls when it
  # detects a non-authenticated request.
  def not_authenticated
    # Make sure that we reference the route from the main app.
    redirect_to main_app.login_path
  end
end
```

### Solving incompatibility with authentication in production

There's a solution proposed by [@adamkangas](https://github.com/adamkangas), for context, see [#147](https://github.com/NoamB/sorcery/issues/147)

This requires forcing `Sorcery::Controller` inclusion at the end of `sorcery.rb` initializer:

```ruby
ActionController::Base.send(:include, Sorcery::Controller)
```
