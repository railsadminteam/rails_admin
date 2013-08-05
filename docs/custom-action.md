## Create a reusable action `ActionName`

```bash
rails plugin new rails_admin_<action_name> -m https://raw.github.com/gist/1621146/ --skip-gemfile --skip-bundle -T -O -S -J --full
```

## Add it to your project

```ruby
# Gemfile

# if uploaded to github with a valid .gemspec (remove TODOS and change owner credentials)
gem 'rails_admin_<action_name>', :git => 'git://github.com/<username>/rails_admin_<action_name>.git'
# or in development mode
gem 'rails_admin_<action_name>', :path => '../rails_admin_<action_name>'
```

## Development documentation

See the Base class your `ActionName` will inherit from: 

[[https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb]]

It is also possible to inherit from any other action class.

## Useful link 
 Here some useful link describing how to create custom action in Rails admin 

 [[http://blog.endpoint.com/2012/03/railsadmin-custom-action-case-study.html]]

## Double pjax

If you're seeing a double call to your new action, try disabling pjax.

```ruby
register_instance_option :pjax? do
  false
end
```

 