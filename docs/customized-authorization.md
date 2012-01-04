```ruby

# in config/initializer/rails_admin.rb

RailsAdmin.config do |config|
  config.authorize_with do 
    redirect_to root_path unless current_user.try(:admin?)
  end
end
```