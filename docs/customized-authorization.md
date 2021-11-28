# Customized authorization

You have access to the controller though `self` or with a block variable. You can decide whether the user should or should not be allowed to continue with something like:

```ruby
# in config/initializer/rails_admin.rb

RailsAdmin.config do |config|
  config.authorize_with do |controller|
    redirect_to main_app.root_path unless current_user.try(:admin?)
  end
end
```
