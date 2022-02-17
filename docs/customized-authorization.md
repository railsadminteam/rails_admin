You have access to the controller though `self` or with a block variable. You can decide whether the user should or should not be allowed to continue with something like:

```ruby
# in config/initializer/rails_admin.rb

RailsAdmin.config do |config|
  config.authorize_with do |controller|
    redirect_to main_app.root_path unless current_user.try(:admin?)
  end
end
```


NOTE: If you are doing custom authorization or your authorization library's `current_user` method is not available in initializer use this:

```
config.parent_controller = "::ApplicationController"
```