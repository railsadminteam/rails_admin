You have access to the controller ('this'), you can decide wether the user should or should not be allowed to continue with something like:

```ruby
# in config/initializer/rails_admin.rb

RailsAdmin.config do |config|
  config.authorize_with do 
    redirect_to root_path unless warden.user.try(:admin?)
  end
end
```