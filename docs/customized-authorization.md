You have access to the controller ('this'), you can decide wether the user should or should not be allowed to continue with something like:

# in config/initializer/rails_admin.rb

```ruby
RailsAdmin.config do |config|
  config.authorize_with do 
    redirect_to root_path unless current_user.try(:admin?)
  end
end
```