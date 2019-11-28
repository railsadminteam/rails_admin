# Using encrypted passwords 

### Add the bcrypt gem to Your Gemfile
`gem 'bcrypt'`

and run bundler 

`bundle install`

### Create the User model 

```
rails g model user name:string password_digest:string
```

Add `has_secure_password` to the model 

```
class User < ApplicationRecord
  has_secure_password
end
```

### Edit config

Edit the `config/initializers/rails_admin.rb` file and add the authentication. 

```
  config.authenticate_with do
    authenticate_or_request_with_http_basic('Login required') do |username, password|
      user = User.where(name: username).first
      user.authenticate(password) if user
    end
  end
```

# Using unencrypted passwords 💣

👉**Saving plain text passwords could get you in trouble with GDPR, you have been warned** 👈

In config/initializers/rails_admin.rb, you can add the following lines of code:

    config.authenticate_with do
      authenticate_or_request_with_http_basic('Login required') do |username, password|
        user = User.where(email: username, password: password, admin: true).first
        user
      end
    end

This will call your User object from the database and check if it exists,
If yes, it will login else it won't.


