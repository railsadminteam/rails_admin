```ruby

# in config/initializer/rails_admin.rb


RailsAdmin.config do |config|
  config.authorize_with do 
    redirect_to root_path unless current_user.try(:admin?)
  end
end
```

# Authorization without devise
...and maybe even without user...
[https://gist.github.com/1278355]([https://gist.github.com/1278355])